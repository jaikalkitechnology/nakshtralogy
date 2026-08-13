/// Client-side views over the curated insight payloads (backend proxies the
/// Nakshatralogy API — see `credentials/cosmic_services.txt` for the sample
/// shapes). Everything parses defensively: a missing/renamed field degrades to
/// null/empty instead of throwing, so a backend tweak never crashes a result
/// sheet that already charged the wallet.
library;

/// Canonical navagraha order used for tables and the chart.
const kPlanetOrder = [
  'Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter',
  'Venus', 'Saturn', 'Rahu', 'Ketu',
];

/// English sign names in zodiac order — used to derive a sign index when a
/// payload names the sign but omits `sign_idx` (the pre-Aug-2026 stub
/// backend shape).
const kSignOrder = [
  'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
  'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces',
];

int? signIdxOf(String? sign) {
  if (sign == null) return null;
  final i = kSignOrder.indexWhere((s) => s.toLowerCase() == sign.toLowerCase());
  return i == -1 ? null : i;
}

/// Two-letter abbreviations placed inside the kundli chart houses.
const kPlanetAbbr = {
  'Sun': 'Su',
  'Moon': 'Mo',
  'Mars': 'Ma',
  'Mercury': 'Me',
  'Jupiter': 'Ju',
  'Venus': 'Ve',
  'Saturn': 'Sa',
  'Rahu': 'Ra',
  'Ketu': 'Ke',
  'Lagna': 'La',
};

double? _num(dynamic v) =>
    v is num ? v.toDouble() : (v is String ? double.tryParse(v) : null);

int? _int(dynamic v) =>
    v is int ? v : (v is num ? v.toInt() : (v is String ? int.tryParse(v) : null));

String? _str(dynamic v) => v is String && v.trim().isNotEmpty ? v : null;

List<String> _strList(dynamic v) =>
    v is List ? v.whereType<String>().toList() : const [];

/// One graha (or the lagna) row: sign / degree / nakshatra / pada + flags.
class InsightPlanet {
  const InsightPlanet({
    required this.name,
    this.sign,
    this.signFull,
    this.signIdx,
    this.degree,
    this.nakshatra,
    this.nakLord,
    this.pada,
    this.dignity,
    this.vakri = false,
    this.combust = false,
    this.vargottam = false,
  });

  /// Field-name fallbacks (`degree_in_sign`, `nakshatra_pada`, `retrograde`,
  /// sign-name-derived index) accept the older stub-backend planet shape, so
  /// the app renders a real table even against a server that predates the
  /// planet-position payload fix instead of a near-empty sheet.
  factory InsightPlanet.fromJson(String name, Map<String, dynamic> j) =>
      InsightPlanet(
        name: name,
        sign: _str(j['sign']),
        signFull: _str(j['sign_full']) ?? _str(j['sign']),
        signIdx: _int(j['sign_idx']) ?? signIdxOf(_str(j['sign'])),
        degree: _num(j['degree']) ?? _num(j['degree_in_sign']),
        nakshatra: _str(j['nakshatra']),
        nakLord: _str(j['nak_lord']),
        pada: _int(j['pada']) ?? _int(j['nakshatra_pada']),
        dignity: _str(j['dignity']),
        vakri: j['vakri'] == true || j['retrograde'] == true,
        combust: j['combust'] == true,
        vargottam: j['vargottam'] == true,
      );

  final String name;
  final String? sign;
  final String? signFull;
  final int? signIdx; // 0 = Aries … 11 = Pisces
  final double? degree;
  final String? nakshatra;
  final String? nakLord;
  final int? pada;
  final String? dignity;
  final bool vakri; // retrograde
  final bool combust;
  final bool vargottam;

  String get abbr => kPlanetAbbr[name] ?? (name.length >= 2 ? name.substring(0, 2) : name);
}

/// Parses a `planets`-style map (`{"Sun": {...}, ...}`) into ordered rows,
/// splitting out the synthetic "Lagna" entry.
({InsightPlanet? lagna, List<InsightPlanet> planets}) parsePlanetMap(
    Map<String, dynamic> raw) {
  InsightPlanet? lagna;
  final byName = <String, InsightPlanet>{};
  for (final e in raw.entries) {
    final v = e.value;
    if (v is! Map<String, dynamic>) continue;
    final p = InsightPlanet.fromJson(e.key, v);
    if (e.key == 'Lagna') {
      lagna = p;
    } else {
      byName[e.key] = p;
    }
  }
  final ordered = <InsightPlanet>[
    for (final n in kPlanetOrder)
      if (byName.containsKey(n)) byName.remove(n)!,
    ...byName.values, // anything non-canonical, last
  ];
  return (lagna: lagna, planets: ordered);
}

/// Parses the older stub-backend `planets` shape — a LIST of
/// `{"name": "Sun", ...}` entries — into the same ordered rows.
({InsightPlanet? lagna, List<InsightPlanet> planets}) parsePlanetList(
    List<dynamic> raw) {
  final asMap = <String, dynamic>{
    for (final e in raw)
      if (e is Map<String, dynamic> && e['name'] is String)
        e['name'] as String: e,
  };
  return parsePlanetMap(asMap);
}

/// Normalizes either `planets` shape (map keyed by name, or the older list
/// of named entries) plus an optional chart-level ascendant into
/// lagna+planets. [chart] supplies `ascendant_sign`/`ascendant` when the
/// planets themselves carry no Lagna entry (the older stub shape).
({InsightPlanet? lagna, List<InsightPlanet> planets}) parseChartPlanets(
    Map<String, dynamic> chart) {
  final rawPlanets = chart['planets'];
  var parsed = switch (rawPlanets) {
    Map<String, dynamic>() => parsePlanetMap(rawPlanets),
    List<dynamic>() => parsePlanetList(rawPlanets),
    _ => (lagna: null as InsightPlanet?, planets: const <InsightPlanet>[]),
  };
  if (parsed.lagna == null && chart['ascendant_sign'] is String) {
    final sign = chart['ascendant_sign'] as String;
    final asc = _num(chart['ascendant']);
    parsed = (
      lagna: InsightPlanet(
        name: 'Lagna',
        sign: sign,
        signFull: sign,
        signIdx: signIdxOf(sign),
        degree: asc == null ? null : asc % 30,
      ),
      planets: parsed.planets,
    );
  }
  return parsed;
}

/// One Vimshottari mahadasha span.
class DashaPeriod {
  const DashaPeriod({required this.planet, this.years, this.start, this.end});

  factory DashaPeriod.fromJson(Map<String, dynamic> j) => DashaPeriod(
        planet: _str(j['planet']) ?? '—',
        years: _num(j['years']),
        start: _str(j['start']),
        end: _str(j['end']),
      );

  final String planet;
  final double? years;
  final String? start;
  final String? end;
}

/// Detailed kundli: lagna + planets (+ optional Vimshottari dashas).
class KundliResult {
  const KundliResult({this.lagna, this.planets = const [], this.dashas = const []});

  factory KundliResult.fromData(Map<String, dynamic> data) {
    // The chart may arrive nested (`data.chart`) or already flattened.
    final chart = data['chart'] is Map<String, dynamic>
        ? data['chart'] as Map<String, dynamic>
        : data;

    final parsed = parseChartPlanets(chart);
    var lagna = parsed.lagna;
    final planets = parsed.planets;
    if (chart['lagna'] is Map<String, dynamic>) {
      lagna = InsightPlanet.fromJson('Lagna', chart['lagna'] as Map<String, dynamic>);
    }

    final vim = data['vimshottari'] is Map<String, dynamic>
        ? data['vimshottari'] as Map<String, dynamic>
        : null;
    final rawDashas = (vim?['dashas'] ?? data['dashas']);
    final dashas = rawDashas is List
        ? [
            for (final d in rawDashas)
              if (d is Map<String, dynamic>) DashaPeriod.fromJson(d),
          ]
        : const <DashaPeriod>[];

    return KundliResult(lagna: lagna, planets: planets, dashas: dashas);
  }

  final InsightPlanet? lagna;
  final List<InsightPlanet> planets;
  final List<DashaPeriod> dashas;
}

/// One gun (koota) row of the Ashtakoot breakdown.
class GunScore {
  const GunScore({required this.gun, this.score, this.max, this.status, this.meaning});

  factory GunScore.fromJson(Map<String, dynamic> j) => GunScore(
        gun: _str(j['gun']) ?? '—',
        score: _num(j['score']),
        max: _num(j['max']),
        status: _str(j['status']),
        meaning: _str(j['meaning']),
      );

  final String gun;
  final double? score;
  final double? max;
  final String? status;
  final String? meaning;
}

/// Love compatibility (kundli milan) — scores + verdict, no internal ids.
class LoveMatchResult {
  const LoveMatchResult({
    this.unifiedScore,
    this.unifiedGrade,
    this.verdict,
    this.verdictExplanation,
    this.plainStatement,
    this.ashtakootScore,
    this.ashtakootGrade,
    this.breakdown = const [],
    this.strengths = const [],
    this.partner1Name,
    this.partner2Name,
  });

  factory LoveMatchResult.fromData(Map<String, dynamic> data) => LoveMatchResult(
        unifiedScore: _num(data['unified_compatibility_score']),
        unifiedGrade: _str(data['unified_grade']),
        verdict: _str(data['compatibility_verdict']),
        verdictExplanation: _str(data['verdict_explanation']),
        plainStatement: _str(data['plain_statement']),
        ashtakootScore: _num(data['ashtakoot_total_score']),
        ashtakootGrade: _str(data['ashtakoot_classical_grade']),
        breakdown: data['ashtakoot_breakdown'] is List
            ? [
                for (final g in data['ashtakoot_breakdown'] as List)
                  if (g is Map<String, dynamic>) GunScore.fromJson(g),
              ]
            : const [],
        strengths: _strList(data['top_compatibility_strengths']),
        partner1Name: _str(data['partner1_name']),
        partner2Name: _str(data['partner2_name']),
      );

  final double? unifiedScore; // 0–100
  final String? unifiedGrade;
  final String? verdict;
  final String? verdictExplanation;
  final String? plainStatement;
  final double? ashtakootScore; // out of 36
  final String? ashtakootGrade;
  final List<GunScore> breakdown;
  final List<String> strengths;
  final String? partner1Name;
  final String? partner2Name;

  bool get isEmpty =>
      unifiedScore == null && ashtakootScore == null && breakdown.isEmpty;
}

/// Daily prediction (forecast): grade + summary + do/avoid lists.
class ForecastResult {
  const ForecastResult({
    this.targetDate,
    this.weekday,
    this.summary,
    this.grade,
    this.qualityScore,
    this.actions = const [],
    this.cautions = const [],
  });

  factory ForecastResult.fromData(Map<String, dynamic> data) => ForecastResult(
        targetDate: _str(data['target_date']),
        weekday: _str(data['target_weekday']),
        summary: _str(data['day_summary']),
        grade: _str(data['day_grade']),
        qualityScore: _num(data['day_quality_score']),
        actions: _strList(data['key_actions_today']),
        cautions: _strList(data['key_cautions_today']),
      );

  final String? targetDate;
  final String? weekday;
  final String? summary;
  final String? grade;
  final double? qualityScore;
  final List<String> actions;
  final List<String> cautions;

  bool get isEmpty => summary == null && grade == null && actions.isEmpty;
}

/// Birthday number: the number itself (+ life path) + traits + analysis.
class BirthdayNumberResult {
  const BirthdayNumberResult({this.number, this.lifePath, this.traits = const []});

  factory BirthdayNumberResult.fromData(Map<String, dynamic> data) {
    int? number;
    for (final key in [
      'birth_day_number', 'birthday_number', 'number', 'moolank', 'birth_number',
    ]) {
      number ??= _int(data[key]);
    }
    var traits = _strList(data['traits']);
    if (traits.isEmpty && data['traits'] is String) {
      traits = (data['traits'] as String)
          .split(RegExp(r'[,•]'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    return BirthdayNumberResult(
      number: number ?? _int(data['life_path_number']),
      lifePath: _int(data['life_path_number']),
      traits: traits,
    );
  }

  final int? number;
  final int? lifePath;
  final List<String> traits;
}

/// A readable text block extracted from an arbitrary payload — used for the
/// horoscope/prediction texts and as the tail of the birthday analysis.
class InsightSection {
  const InsightSection({required this.title, this.text, this.bullets = const []});
  final String title;
  final String? text;
  final List<String> bullets;
}

const _internalKeys = {
  'status', 'version', 'domain', 'engine', 'birth_jd', 'meta', 'pdf_url',
  'source', 'provider',
  'traits', 'birthday_number', 'number', 'moolank', 'birth_number',
  'birth_day_number', 'life_path_number',
};

bool _isInternalKey(String key) =>
    key.startsWith('_') ||
    _internalKeys.contains(key) ||
    key.endsWith('_id') ||
    key.endsWith('_idx') ||
    key == 'id';

String titleCaseKey(String s) => s
    .replaceAll('_', ' ')
    .split(' ')
    .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
    .join(' ');

String? _scalarText(dynamic v) {
  if (v is String && v.trim().isNotEmpty) return v;
  if (v is num) return v == v.round() ? '${v.round()}' : '$v';
  return null;
}

/// Pulls the human-readable strings/numbers/lists out of a payload, dropping
/// internal ids and machine fields. Nested maps flatten one level into
/// "Label: value" bullet groups. Order follows the payload.
List<InsightSection> genericSections(Map<String, dynamic> data) {
  final out = <InsightSection>[];
  for (final e in data.entries) {
    if (_isInternalKey(e.key)) continue;
    final v = e.value;
    final scalar = _scalarText(v);
    if (scalar != null) {
      out.add(InsightSection(title: titleCaseKey(e.key), text: scalar));
    } else if (v is List) {
      final bullets = v.whereType<String>().toList();
      if (bullets.isNotEmpty) {
        out.add(InsightSection(title: titleCaseKey(e.key), bullets: bullets));
      }
    } else if (v is Map<String, dynamic>) {
      final bullets = <String>[];
      for (final n in v.entries) {
        if (_isInternalKey(n.key)) continue;
        final s = _scalarText(n.value);
        if (s != null) {
          bullets.add('${titleCaseKey(n.key)}: $s');
        } else if (n.value is List) {
          bullets.addAll((n.value as List).whereType<String>());
        }
      }
      if (bullets.isNotEmpty) {
        out.add(InsightSection(title: titleCaseKey(e.key), bullets: bullets));
      }
    }
  }
  return out;
}

/// Western sun sign for a birth date — `/horoscope/daily` requires a
/// `zodiac_sign` alongside the birth details.
String zodiacSignFor(DateTime dob) {
  const cutoffs = [
    // (last day of the sign starting in the previous month, sign until then)
    (19, 'Capricorn', 'Aquarius'), // Jan
    (18, 'Aquarius', 'Pisces'), // Feb
    (20, 'Pisces', 'Aries'), // Mar
    (19, 'Aries', 'Taurus'), // Apr
    (20, 'Taurus', 'Gemini'), // May
    (20, 'Gemini', 'Cancer'), // Jun
    (22, 'Cancer', 'Leo'), // Jul
    (22, 'Leo', 'Virgo'), // Aug
    (22, 'Virgo', 'Libra'), // Sep
    (22, 'Libra', 'Scorpio'), // Oct
    (21, 'Scorpio', 'Sagittarius'), // Nov
    (21, 'Sagittarius', 'Capricorn'), // Dec
  ];
  final (cutoff, before, after) = cutoffs[dob.month - 1];
  return dob.day <= cutoff ? before : after;
}

/// Row of `GET /insights/reports` — a past paid insight with its PDF.
class InsightReport {
  const InsightReport({
    required this.id,
    required this.type,
    this.subjectName,
    this.createdAt,
    this.amount,
    this.pdfUrl,
  });

  factory InsightReport.fromJson(Map<String, dynamic> j) => InsightReport(
        id: '${j['id']}',
        type: _str(j['type']) ?? 'report',
        subjectName: _str(j['subject_name']),
        createdAt: j['created_at'] is String
            ? DateTime.tryParse(j['created_at'] as String)
            : null,
        amount: '${j['amount'] ?? j['amount_paid'] ?? ''}'.isEmpty
            ? null
            : '${j['amount'] ?? j['amount_paid']}',
        pdfUrl: _str(j['pdf_url']),
      );

  final String id;
  final String type; // service key, e.g. "detailed_kundli"

  /// Who the report was for — "Name" (or "Name1 ♥ Name2" for love
  /// compatibility). Null on rows generated before names were stored.
  final String? subjectName;
  final DateTime? createdAt;
  final String? amount;
  final String? pdfUrl;
}

/// The absolute PDF link of a fresh generation — the backend puts it at the
/// top level of the envelope; older builds nested it under `report`/`data`.
String? pdfUrlOf(Map<String, dynamic> response) {
  final direct = _str(response['pdf_url']);
  if (direct != null) return direct;
  final report = response['report'];
  if (report is Map<String, dynamic>) {
    final r = _str(report['pdf_url']);
    if (r != null) return r;
  }
  final data = response['data'];
  if (data is Map<String, dynamic>) return _str(data['pdf_url']);
  return null;
}
