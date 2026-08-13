// End-to-end flow test for the Cosmic Services "black screen".
//
// Reproduces the REAL app structure: InsightsScreen lives inside a
// StatefulShellBranch, i.e. under a NESTED navigator, while showDialog
// (the paid-generation loading spinner) defaults to useRootNavigator:
// true. The two must agree on which navigator to pop — a bare
// `Navigator.of(context).pop()` resolves to the NEAREST (branch)
// navigator, which pops the InsightsScreen page itself (black area under
// the shell) and leaves the dialog + its dark barrier up forever on the
// root navigator: the reported black screen.
//
// This harness mirrors that structure with a nested Navigator and drives
// the REAL InsightsScreen + preflight sheet + result sheet, with only the
// HTTP layer faked (returning verbatim captured backend responses).
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hj_core/hj_core.dart';

import 'package:hindustani_user/core/di.dart';
import 'package:hindustani_user/features/insights/insights_repository.dart';
import 'package:hindustani_user/features/insights/ui/insights_screen.dart';
import 'package:hindustani_user/l10n/app_localizations.dart';

class _FakeApiClient extends ApiClient {
  _FakeApiClient()
      : super(
          config: const AppConfig(apiBaseUrl: 'http://test.invalid/v1'),
          tokenStore: TokenStore(),
        );

  final calls = <String>[];
  Map<String, dynamic>? lastPostBody;

  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    calls.add('GET $path');
    if (path == '/cosmic-services') {
      return [
        for (final key in [
          'daily_horoscope', 'detailed_kundli', 'planet_position',
          'love_compatibility', 'birthday_number', 'daily_prediction',
        ])
          {'key': key, 'price': '79.00'},
      ];
    }
    throw ApiException(404, 'no fake for GET $path');
  }

  @override
  Future<dynamic> post(String path, {Object? body, bool noAuth = false}) async {
    calls.add('POST $path');
    if (body is Map<String, dynamic>) lastPostBody = body;
    // Realistic latency so the loading dialog actually gets a frame — the
    // flow under test is tap → spinner → response → dismiss.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (path == '/horoscope/planet-position') {
      return jsonDecode(
          File('test/fixtures/insight_planet.json').readAsStringSync());
    }
    throw ApiException(404, 'no fake for POST $path');
  }

  @override
  Future<dynamic> patch(String path, {Object? body}) async {
    calls.add('PATCH $path');
    if (path == '/me') {
      return {
        'id': 'u1',
        'name': 'Flow Tester',
        'mobile': '9911223344',
        'country_code': '+91',
        'gender': 'male',
        'dob': '1995-08-15',
        'birth_time': '09:30:00',
        'birth_place': 'Delhi, India',
      };
    }
    throw ApiException(404, 'no fake for PATCH $path');
  }
}

const _completeUser = AppUser(
  id: 'u1',
  name: 'Flow Tester',
  mobile: '9911223344',
  countryCode: '+91',
  gender: 'male',
  dob: '1995-08-15',
  birthTime: '09:30:00',
  birthPlace: 'Delhi, India',
);

// ignore: library_private_types_in_public_api — test-local fake, single file
late _FakeApiClient fakeApi;

Future<void> pumpInsightsInShell(WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    // Nested Navigator = the StatefulShellBranch's own navigator in the
    // real app. showDialog targets the OUTER (root) MaterialApp navigator.
    home: Scaffold(
      body: Navigator(
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (_) => const InsightsScreen(),
        ),
      ),
    ),
  ));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() async {
    await getIt.reset();
    fakeApi = _FakeApiClient();
    getIt.registerSingleton<InsightsRepository>(InsightsRepository(fakeApi));
    final authRepo = AuthRepository(api: fakeApi, tokens: TokenStore());
    getIt.registerSingleton<AuthRepository>(authRepo);
    getIt.registerSingleton<AuthCubit>(AuthCubit(authRepo));
  });

  testWidgets(
      'planet position: tile tap → PREFILLED details sheet → explicit '
      'Generate → loading dialog → result sheet, screen survives',
      (tester) async {
    getIt<AuthCubit>().onAuthenticated(_completeUser);
    await pumpInsightsInShell(tester);

    // Tap the Planet Position tile (Icons.public per InsightsScreen._tiles).
    await tester.tap(find.byIcon(Icons.public));
    await tester.pumpAndSettle();

    // The details sheet opens PRE-FILLED from the profile — and no
    // generation API call has fired yet (only on the explicit Generate).
    expect(find.widgetWithText(TextField, 'Flow Tester'), findsOneWidget,
        reason: 'name must be pre-filled from the profile');
    expect(find.widgetWithText(TextField, 'Delhi, India'), findsOneWidget,
        reason: 'birth place must be pre-filled from the profile');
    expect(find.text('1995-08-15'), findsOneWidget,
        reason: 'dob must be pre-filled from the profile');
    expect(
        fakeApi.calls.where((c) => c.startsWith('POST')), isEmpty,
        reason: 'the API must NOT be called before the Generate tap');

    // The report may be for someone else — edit the name.
    await tester.enterText(
        find.widgetWithText(TextField, 'Flow Tester'), 'Someone Else');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ElevatedButton)); // Generate report
    await tester.pump(); // dialog frame
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    // The loading dialog must be gone…
    expect(find.byType(CircularProgressIndicator), findsNothing,
        reason: 'loading dialog barrier must be dismissed — a surviving '
            'barrier is the reported permanent black screen');
    // …the InsightsScreen must still exist under the shell…
    expect(find.byType(InsightsScreen), findsOneWidget,
        reason: 'the wrong-navigator pop removes the InsightsScreen page '
            'itself — the black area under the stuck dialog');
    // …the generation used the EDITED name, nothing was saved to the
    // profile, and the result sheet is showing real planet rows.
    expect(fakeApi.calls, contains('POST /horoscope/planet-position'));
    expect(fakeApi.lastPostBody?['name'], 'Someone Else');
    expect(fakeApi.calls.where((c) => c == 'PATCH /me'), isEmpty,
        reason: 'editing the form must not overwrite the profile');
    expect(find.text('Sun'), findsOneWidget);
    expect(find.text('Moon'), findsOneWidget);
  });

  testWidgets('dismissing the details sheet makes no API call',
      (tester) async {
    getIt<AuthCubit>().onAuthenticated(_completeUser);
    await pumpInsightsInShell(tester);

    await tester.tap(find.byIcon(Icons.public));
    await tester.pumpAndSettle();
    // Swipe the sheet away without tapping Generate.
    await tester.tapAt(const Offset(400, 30)); // barrier tap dismisses
    await tester.pumpAndSettle();

    expect(fakeApi.calls.where((c) => c.startsWith('POST')), isEmpty);
    expect(find.byType(InsightsScreen), findsOneWidget);
  });

  testWidgets(
      'profile missing a field: sheet still opens prefilled with the rest '
      'and generation works after filling it',
      (tester) async {
    getIt<AuthCubit>().onAuthenticated(const AppUser(
      id: 'u1',
      name: 'Flow Tester',
      mobile: '9911223344',
      countryCode: '+91',
      gender: 'male',
      dob: '1995-08-15',
      birthTime: '09:30:00',
    ));
    await pumpInsightsInShell(tester);

    await tester.tap(find.byIcon(Icons.public));
    await tester.pumpAndSettle();

    // Name arrives prefilled; the missing place field is simply blank.
    expect(find.widgetWithText(TextField, 'Flow Tester'), findsOneWidget);
    final placeField = find.byType(TextField).last;
    await tester.enterText(placeField, 'Mumbai, India');
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(fakeApi.calls, contains('POST /horoscope/planet-position'));
    expect(fakeApi.lastPostBody?['place'], 'Mumbai, India');
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(InsightsScreen), findsOneWidget);
    expect(find.text('Sun'), findsOneWidget);
  });
}
