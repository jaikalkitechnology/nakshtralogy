// Defensive-parse smoke tests for the Phase-C full-analysis section models.
// Every parser must degrade gracefully (never throw) on missing/garbage data.
import 'package:flutter_test/flutter_test.dart';
import 'package:hindustani_user/features/insights/insight_models.dart';

const _chart = {
  'name': 'Test Native',
  'planets': {
    'Sun': {'sign': 'Le', 'sign_full': 'Leo', 'sign_idx': 4, 'vakri': false},
    'Moon': {'sign': 'Sc', 'sign_full': 'Scorpio', 'sign_idx': 7},
    'Mars': {'sign': 'Vi', 'sign_full': 'Virgo', 'sign_idx': 5, 'vakri': true},
    'Lagna': {'sign': 'Li', 'sign_full': 'Libra', 'sign_idx': 6},
  },
  'divisionals': {
    'Sun': {'D1': 'Le', 'D9': 'Ar'},
    'Moon': {'D1': 'Sc', 'D9': 'Ge'},
    'Mars': {'D1': 'Vi', 'D9': 'Cp'},
    'Lagna': {'D1': 'Li', 'D9': 'Ta'},
  },
};

void main() {
  group('divisionalPlanets', () {
    test('maps varga signs and lagna from the divisionals map', () {
      final d = divisionalPlanets(
        (_chart['divisionals'] as Map).cast<String, dynamic>(),
        (_chart['planets'] as Map).cast<String, dynamic>(),
        'D9',
      );
      expect(d.lagnaIdx, signIdxOfShort('Ta')); // Taurus = 1
      expect(d.planets.length, 3);
      final sun = d.planets.firstWhere((p) => p.name == 'Sun');
      expect(sun.signIdx, 0); // Aries
      final mars = d.planets.firstWhere((p) => p.name == 'Mars');
      expect(mars.vakri, isTrue); // carried over from D1 planet flags
    });

    test('returns empty rows on an empty map (no throw)', () {
      final d = divisionalPlanets(const {}, const {}, 'D9');
      expect(d.planets, isEmpty);
      expect(d.lagnaIdx, isNull);
    });
  });

  test('signIdxOfShort accepts short codes and full names', () {
    expect(signIdxOfShort('Ar'), 0);
    expect(signIdxOfShort('Pi'), 11);
    expect(signIdxOfShort('Aries'), 0);
    expect(signIdxOfShort('garbage'), isNull);
    expect(signIdxOfShort(null), isNull);
  });

  test('GocharResult parses rashis + highlights', () {
    final g = GocharResult.fromData(const {
      'date': 'today',
      'best': 'Aries',
      'worst': 'Scorpio',
      'rashis': [
        {'rashi': 'Aries', 'rashi_idx': 0, 'score': 3, 'grade': 'Good'},
        {'rashi': 'Scorpio', 'rashi_idx': 7, 'score': -2, 'grade': 'Weak'},
      ],
    });
    expect(g.rashis.length, 2);
    expect(g.best, 'Aries');
    expect(g.rashis.first.score, 3);
    expect(GocharResult.fromData(const {}).isEmpty, isTrue);
  });

  test('AnalysisSummary handles both dosh and yoga shapes', () {
    final dosh = AnalysisSummary.fromData(const {
      'total': 33,
      'active': 1,
      'doshas': [
        {'name': 'Mangal Dosh', 'present': true, 'score': 72, 'factors': ['Mars 8th']},
        {'name': 'Kaal Sarp', 'present': false, 'score': 0},
      ],
    }, 'doshas');
    expect(dosh.total, 33);
    expect(dosh.activeItems.length, 1);
    expect(dosh.activeItems.first.name, 'Mangal Dosh');

    final yoga = AnalysisSummary.fromData(const {
      'yogas': [
        {'name': 'Gajakesari', 'present': true, 'score': 80},
      ],
    }, 'yogas');
    expect(yoga.activeItems.single.score, 80);

    expect(AnalysisSummary.fromData(const {}, 'doshas').items, isEmpty);
  });

  test('ShadbalaResult parses score + balas (virupas → rupas)', () {
    final s = ShadbalaResult.fromData(const {
      'planets': {
        'Sun': {'score_100': 95, 'total_virupas': 420, 'sthana_bala': 180, 'dig_bala': 40},
      },
    });
    expect(s.planets.single.planet, 'Sun');
    expect(s.planets.single.score, 95);
    expect(s.planets.single.balas['sthana_bala'], closeTo(3.0, 0.001)); // 180/60
    expect(ShadbalaResult.fromData(const {}).isEmpty, isTrue);
  });

  test('AshtakavargaResult parses SAV + BAV', () {
    final av = AshtakavargaResult.fromData(const {
      'sav': {'Ar': 28, 'Ta': 30},
      'sav_total': 337,
      'planets_bav': {
        'Sun': {'total_rekha': 48, 'natal_sign_score': 5},
      },
    });
    expect(av.sav['Ar'], 28);
    expect(av.savTotal, 337);
    expect(av.planetsBav['Sun']!['total_rekha'], 48);
    expect(AshtakavargaResult.fromData(const {}).isEmpty, isTrue);
  });

  test('BhavaResult parses H01..H12', () {
    final b = BhavaResult.fromData(const {
      'H01': {'house': 1, 'sign': 'Li', 'lord': 'Venus', 'sav': 27, 'score': 72, 'occupants': ['Lagna']},
      'H07': {'house': 7, 'sign': 'Ar', 'lord': 'Mars', 'score': 55},
    });
    expect(b.houses.length, 2);
    expect(b.houses.first.lord, 'Venus');
    expect(b.houses.first.occupants, ['Lagna']);
    expect(BhavaResult.fromData(const {}).isEmpty, isTrue);
  });

  test('LifeAreasResult parses ordered areas', () {
    final la = LifeAreasResult.fromData(const {
      'career': {'score': 78, 'grade': 'Good', 'factors': ['x']},
      'health': {'score': 60, 'grade': 'Average'},
    });
    expect(la.areas.map((a) => a.key), containsAll(['career', 'health']));
    expect(la.areas.first.score, 78);
    expect(LifeAreasResult.fromData(const {}).isEmpty, isTrue);
  });
}
