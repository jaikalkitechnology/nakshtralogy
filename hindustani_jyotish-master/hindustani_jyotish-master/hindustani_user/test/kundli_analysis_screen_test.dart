// Widget smoke test for the Phase-C full kundli viewer. A fake ApiClient
// returns canned section envelopes; every one of the 12 tabs must build (and
// its lazy loader resolve) without throwing. No Moola tab exists.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hj_core/hj_core.dart';

import 'package:hindustani_user/core/di.dart';
import 'package:hindustani_user/features/insights/insights_repository.dart';
import 'package:hindustani_user/features/insights/ui/kundli_analysis_screen.dart';
import 'package:hindustani_user/l10n/app_localizations.dart';

Map<String, dynamic> _env(Object? data) => {'status': 'success', 'data': data};

const _chart = {
  'name': 'Test Native',
  'dob': '15/08/1995',
  'tob': '09:30',
  'place': 'Delhi',
  'lagna': {'sign': 'Li', 'sign_full': 'Libra', 'sign_idx': 6, 'degree': 12.3},
  'planets': {
    'Sun': {'sign': 'Le', 'sign_full': 'Leo', 'sign_idx': 4, 'degree': 28.9, 'vakri': false},
    'Moon': {'sign': 'Sc', 'sign_full': 'Scorpio', 'sign_idx': 7, 'degree': 5.1},
    'Mars': {'sign': 'Vi', 'sign_full': 'Virgo', 'sign_idx': 5, 'vakri': true},
    'Lagna': {'sign': 'Li', 'sign_full': 'Libra', 'sign_idx': 6},
  },
  'divisionals': {
    'Sun': {'D1': 'Le', 'D9': 'Ar', 'D10': 'Sc'},
    'Moon': {'D1': 'Sc', 'D9': 'Ge', 'D10': 'Li'},
    'Mars': {'D1': 'Vi', 'D9': 'Cp', 'D10': 'Ta'},
    'Lagna': {'D1': 'Li', 'D9': 'Ta', 'D10': 'Vi'},
  },
};

const _complete = {
  'dosh_analysis': {
    'total': 33,
    'active': 1,
    'doshas': [
      {'name': 'Mangal Dosh', 'present': true, 'score': 72, 'category': 'Marriage', 'factors': ['Mars in 8th']},
    ],
  },
  'yoga_analysis': {
    'total': 51,
    'active': 1,
    'yogas': [
      {'name': 'Gajakesari', 'present': true, 'score': 80, 'category': 'Wealth'},
    ],
  },
  'shadbala': {
    'planets': {
      'Sun': {'score_100': 95, 'total_virupas': 420, 'sthana_bala': 180, 'dig_bala': 40, 'kala_bala': 60, 'chesta_bala': 30, 'naisargika_bala': 60, 'drik_bala': 50},
      'Moon': {'score_100': 70, 'total_virupas': 360, 'sthana_bala': 120, 'dig_bala': 30, 'kala_bala': 50, 'chesta_bala': 40, 'naisargika_bala': 51, 'drik_bala': 20},
    },
  },
  'ashtakavarga': {
    'sav': {'Ar': 28, 'Ta': 30, 'Ge': 25, 'Cn': 22, 'Le': 31, 'Vi': 29, 'Li': 27, 'Sc': 24, 'Sg': 33, 'Cp': 26, 'Aq': 30, 'Pi': 22},
    'sav_total': 337,
    'planets_bav': {
      'Sun': {'total_rekha': 48, 'natal_sign_score': 5},
      'Saturn': {'total_rekha': 39},
    },
  },
  'aspect_matrix': {
    'planets': ['Sun', 'Moon'],
    'graha_drishti': {
      'Sun': {'Moon': {'house': 7, 'type': 'full', 'strength': 'strong'}},
    },
    'rashi_drishti': {'Ar': ['Li', 'Sc']},
  },
  'life_areas': {'career': {'score': 78, 'grade': 'Good', 'factors': ['x']}},
  'bhava_strength': {
    'H01': {'house': 1, 'sign': 'Li', 'lord': 'Venus', 'sav': 27, 'score': 72, 'occupants': ['Lagna']},
    'H07': {'house': 7, 'sign': 'Ar', 'lord': 'Mars', 'sav': 24, 'score': 55, 'occupants': <String>[]},
  },
};

const _vim = {
  'system': 'Vimshottari',
  'total_years': 120,
  'moon_lord': 'Mercury',
  'balance_yrs': 3.5,
  'dashas': [
    {
      'planet': 'Mercury',
      'years': 17,
      'start': '15/08/1995',
      'end': '15/08/2012',
      'sub': [
        {'planet': 'Mercury', 'start': '15/08/1995', 'end': '12/01/1998', 'months': 29, 'sub': <dynamic>[]},
      ],
    },
    {'planet': 'Ketu', 'years': 7, 'start': '15/08/2012', 'end': '15/08/2019', 'sub': <dynamic>[]},
  ],
};

const _gochar = {
  'date': 'today',
  'moon_sign': 'Scorpio',
  'rashis': [
    {'rashi': 'Aries', 'rashi_idx': 0, 'score': 3, 'grade': 'Good', 'flags': <String>[]},
    {'rashi': 'Scorpio', 'rashi_idx': 7, 'score': -2, 'grade': 'Weak', 'flags': <String>[]},
  ],
  'best': 'Aries',
  'worst': 'Scorpio',
};

class _FakeApiClient extends ApiClient {
  _FakeApiClient()
      : super(
          config: const AppConfig(apiBaseUrl: 'http://test.invalid/v1'),
          tokenStore: TokenStore(),
        );

  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    if (path.endsWith('/chart')) return _env(_chart);
    if (path.endsWith('/analysis/complete')) return _env(_complete);
    if (path.contains('/dasha/vimshottari')) return _env(_vim);
    if (path.contains('/gochar/today')) return _env(_gochar);
    if (path.endsWith('/analysis/dosh')) return _env(_complete['dosh_analysis']);
    if (path.endsWith('/analysis/yoga')) return _env(_complete['yoga_analysis']);
    if (path.endsWith('/analysis/shadbala')) return _env(_complete['shadbala']);
    if (path.endsWith('/analysis/ashtakavarga')) return _env(_complete['ashtakavarga']);
    if (path.endsWith('/analysis/aspects')) return _env(_complete['aspect_matrix']);
    if (path.endsWith('/analysis/bhava')) return _env(_complete['bhava_strength']);
    return _env(const <String, dynamic>{});
  }
}

Future<void> _openTab(WidgetTester tester, String label) async {
  final tab = find.descendant(of: find.byType(TabBar), matching: find.text(label));
  await tester.ensureVisible(tab);
  await tester.pumpAndSettle();
  await tester.tap(tab);
  await tester.pumpAndSettle();
}

void main() {
  setUp(() async {
    await getIt.reset();
    getIt.registerSingleton<InsightsRepository>(InsightsRepository(_FakeApiClient()));
  });

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const KundliAnalysisScreen(chartId: 'c1', subjectName: 'Test Native'),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('loads the chart and shows the Summary tab', (tester) async {
    await pump(tester);
    expect(find.text('Test Native'), findsWidgets);
    expect(find.text('Summary'), findsOneWidget); // tab label
    // No Moola tab anywhere.
    expect(find.text('Moola'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('every one of the 12 tabs builds without throwing', (tester) async {
    await pump(tester);
    const tabs = [
      'Summary', 'Planets', 'Kundli', 'Divisions', 'Vimshottari', 'Gochar',
      'Dosh', 'Yoga', 'Shadbala', 'Ashtakavarga', 'Aspects', 'Bhava',
    ];
    for (final label in tabs) {
      await _openTab(tester, label);
      expect(tester.takeException(), isNull, reason: 'tab "$label" threw while building');
    }
    // A seeded analysis tab rendered its content, and the dasha tab loaded.
    await _openTab(tester, 'Dosh');
    expect(find.text('Mangal Dosh'), findsWidgets);
    await _openTab(tester, 'Vimshottari');
    expect(find.text('Mercury'), findsWidgets);
  });
}
