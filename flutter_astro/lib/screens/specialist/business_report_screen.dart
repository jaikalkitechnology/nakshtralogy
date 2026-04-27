import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

class BusinessReportScreen extends StatefulWidget {
  final String chartId, chartName;
  final Map<String, dynamic>? preloadedData;
  const BusinessReportScreen({super.key, required this.chartId, required this.chartName, this.preloadedData});

  @override
  State<BusinessReportScreen> createState() => _BizState();
}

class _BizState extends State<BusinessReportScreen> {
  final _api = ApiService();
  Map<String, dynamic>? _d;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.preloadedData != null) { _d = widget.preloadedData; _loading = false; }
    else _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final r = await _api.runSpecialist('business', widget.chartId);
      if (!mounted) return;
      if (r['statusCode'] == 200 && r['status'] == 'success') {
        setState(() { _d = (r['data'] as Map).cast<String, dynamic>(); _loading = false; });
      } else setState(() { _error = r['detail']?.toString() ?? 'Failed'; _loading = false; });
    } catch (e) { if (!mounted) return; setState(() { _error = e.toString(); _loading = false; }); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFF0A0A24),
      body: _loading ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _error != null ? _errV()
          : _d != null ? _report() : const SizedBox.shrink());
  }

  Widget _errV() => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    const Icon(Icons.error_outline, color: AppColors.error, size: 48), const SizedBox(height: 12),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(_error!, style: const TextStyle(color: AppColors.smoke), textAlign: TextAlign.center)),
    const SizedBox(height: 16), ElevatedButton(onPressed: _load, child: const Text('Retry')),
  ]));

  Widget _report() {
    final d = _d!;
    return CustomScrollView(slivers: [
      SliverAppBar(backgroundColor: const Color(0xFF0A0A24), pinned: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory), onPressed: () => Navigator.pop(context)),
        title: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
          Text(widget.chartName.toUpperCase(), style: const TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 1.5, fontFamily: 'monospace')),
          const Text.rich(TextSpan(children: [
            TextSpan(text: 'Business ', style: TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w600)),
            TextSpan(text: '& Startup', style: TextStyle(color: AppColors.gold, fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500)),
          ])),
        ]),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.refresh, color: AppColors.ivory, size: 18), onPressed: _load)],
      ),
      SliverList(delegate: SliverChildListDelegate([
        _heroScores(d), _founderArchetype(d), _karakas(d), _houses(d),
        _divisionals(d), _yogas(d), _domains(d), _businessStyle(d),
        _founderSkills(d), _funding(d), _timing(d), _risks(d),
        _remedies(d), _confidence(d), _aiBar(d), const SizedBox(height: 30),
      ])),
    ]);
  }

  // ═══ HERO SCORES ═══
  Widget _heroScores(Map d) {
    final overall = _n(d, 'overall_business_strength_score');
    final entre = _n(d, 'entrepreneurship_potential_score');
    final venture = _n(d, 'venture_success_potential_score');
    final h11 = _n(d, 'eleventh_house_strength_score');
    final gains = _n(d, 'gains_potential_score');
    final investor = _n(d, 'investor_attraction_score');
    return Container(margin: const EdgeInsets.fromLTRB(16, 12, 16, 12), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.10), AppColors.saffron.withOpacity(0.04)]),
        borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.gold.withOpacity(0.25))),
      child: Column(children: [
        _label('⚡ CORE BUSINESS SCORES'),
        const SizedBox(height: 14),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _ring(overall, 'OVERALL\nBUSINESS', AppColors.gold),
          _ring(entre, 'ENTREPRE-\nNEURSHIP', AppColors.aurora),
          _ring(venture, 'VENTURE\nSUCCESS', AppColors.cosmicPink),
        ]),
        const SizedBox(height: 14),
        Container(padding: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.gold.withOpacity(0.2), width: 0.5))),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _mini(h11, '11TH HOUSE'), _mini(gains, 'GAINS'), _mini(investor, 'INVESTOR'),
          ])),
      ]));
  }

  // ═══ FOUNDER ARCHETYPE ═══
  Widget _founderArchetype(Map d) {
    final arch = d['founder_archetype']?.toString() ?? '';
    if (arch.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      _secH('Founder', 'Archetype', '1 KEY'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.cosmicPink.withOpacity(0.15), const Color(0xFF4A3B8C).withOpacity(0.15)]),
          borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cosmicPink.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('PRIMARY ARCHETYPE', style: TextStyle(color: AppColors.cosmicPink, fontSize: 9, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(_tc(arch), style: const TextStyle(color: AppColors.ivory, fontSize: 22, fontWeight: FontWeight.w600, fontFamily: 'serif')),
          const SizedBox(height: 8),
          Text(d['core_business_theme']?['description']?.toString() ?? '',
            style: const TextStyle(color: AppColors.lavender, fontSize: 10, height: 1.4, fontStyle: FontStyle.italic)),
        ])),
    ]);
  }

  // ═══ KARAKAS ═══
  Widget _karakas(Map d) {
    return Column(children: [
      _secH('Jaimini', 'Karakas', '8 KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          Expanded(child: _karakaCard('AMATYAKARAKA', d['amatyakaraka_planet']?.toString() ?? '—',
            'Business direction', d['amatyakaraka_business_direction']?.toString() ?? '')),
          const SizedBox(width: 8),
          Expanded(child: _karakaCard('DARAKARAKA', d['darakaraka_planet']?.toString() ?? '—',
            'Partner signature', d['darakaraka_business_partner_signature']?.toString() ?? '')),
        ])),
      if (d['ideal_cofounder_archetype'] != null) Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 4), padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.08),
          borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
          border: const Border(left: BorderSide(color: AppColors.gold, width: 3))),
        child: Text('Ideal co-founder: ${d['ideal_cofounder_archetype']}',
          style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.5, fontStyle: FontStyle.italic))),
    ]);
  }

  Widget _karakaCard(String tag, String planet, String meaning, String detail) {
    return Container(padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.12), AppColors.gold.withOpacity(0.02)]),
        borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.gold.withOpacity(0.25))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(tag, style: const TextStyle(color: AppColors.gold, fontSize: 8, letterSpacing: 1.5, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(planet, style: const TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'serif')),
        Text(meaning, style: const TextStyle(color: AppColors.smoke, fontSize: 8)),
        if (detail.isNotEmpty) ...[const SizedBox(height: 4),
          Text(detail, maxLines: 3, overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.lavender, fontSize: 8, fontStyle: FontStyle.italic))],
      ]));
  }

  // ═══ 10TH + 11TH HOUSES ═══
  Widget _houses(Map d) {
    return Column(children: [
      _secH('10th & 11th', 'Houses', '22 KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          Expanded(child: _houseCard('10TH · KARMA',
            d['tenth_house_sign_name']?.toString() ?? '—', d['tenth_lord_planet']?.toString() ?? '—',
            '${d['tenth_lord_house'] ?? "?"}H', _n(d, 'tenth_house_strength_score'))),
          const SizedBox(width: 8),
          Expanded(child: _houseCard('11TH · LABHA',
            d['eleventh_house_sign_name']?.toString() ?? '—', d['eleventh_lord_planet']?.toString() ?? '—',
            '${d['eleventh_lord_house'] ?? "?"}H', _n(d, 'eleventh_house_strength_score'))),
        ])),
    ]);
  }

  Widget _houseCard(String title, String sign, String lord, String placed, double strength) {
    final c = strength >= 70 ? AppColors.success : strength >= 50 ? AppColors.gold : AppColors.warning;
    return Container(padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.6), borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withOpacity(0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: AppColors.gold, fontSize: 8, letterSpacing: 1.5, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(sign, style: const TextStyle(color: AppColors.ivory, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'serif')),
        _kv('LORD', lord), _kv('PLACED', placed),
        const SizedBox(height: 4),
        Row(children: [const Text('STRENGTH', style: TextStyle(color: AppColors.smoke, fontSize: 8, fontFamily: 'monospace')),
          const Spacer(), Text('${strength.toStringAsFixed(1)}', style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w700))]),
        const SizedBox(height: 3),
        ClipRRect(borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(value: strength / 100, minHeight: 4, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c))),
      ]));
  }

  Widget _kv(String k, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(k, style: const TextStyle(color: AppColors.smoke, fontSize: 8, fontFamily: 'monospace')),
      Text(v, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'serif')),
    ]));

  // ═══ DIVISIONAL VALIDATION ═══
  Widget _divisionals(Map d) {
    final d10 = (d['d10_validation'] as Map?)?.cast<String, dynamic>() ?? {};
    final d11 = (d['d11_validation'] as Map?)?.cast<String, dynamic>() ?? {};
    final d9 = (d['d9_validation'] as Map?)?.cast<String, dynamic>() ?? {};
    final d60 = (d['d60_validation'] as Map?)?.cast<String, dynamic>() ?? {};
    if (d10.isEmpty && d11.isEmpty && d9.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      _secH('Divisional', 'Validation', 'D10·D11·D9·D60'),
      if (d10.isNotEmpty) _divCard('D-10 KARMA', [
        ['10L', d10['d10_10_lord_dignity']], ['AK', d10['d10_amatyakaraka_dignity']],
        ['DK', d10['d10_darakaraka_dignity']], ['Sun', d10['d10_sun_dignity']],
        ['Mercury', d10['d10_mercury_dignity']],
      ], d10['d10_overall_business_standing'], d10['d10_primary_venture_signature']),
      if (d11.isNotEmpty) _divCard('D-11 LABHAMSHA', [
        ['11L', d11['d11_11_lord_dignity']], ['Jupiter', d11['d11_jupiter_dignity']],
        ['Venus', d11['d11_venus_dignity']], ['Mercury', d11['d11_mercury_dignity']],
      ], '${(d11['d11_gains_quality_score'] as num?)?.toStringAsFixed(0) ?? "?"}%', d11['d11_labhamsha_signature']),
      if (d9.isNotEmpty) _divCard('D-9 DHARMA', [
        ['10L', d9['d9_10_lord_dignity']], ['AK', d9['d9_amatyakaraka_dignity']],
      ], '${(d9['d9_dharmic_business_score'] as num?)?.toStringAsFixed(0) ?? "?"}%', d9['d9_business_dharma_signature']),
    ]);
  }

  Widget _divCard(String title, List<List<dynamic>> rows, String? verdict, String? notes) {
    return Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 8), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withOpacity(0.15))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.gold, AppColors.saffron]), borderRadius: BorderRadius.circular(8)),
          child: Text(title, style: const TextStyle(color: AppColors.midnight, fontSize: 9, letterSpacing: 1, fontFamily: 'monospace', fontWeight: FontWeight.w700))),
        const SizedBox(height: 8),
        ...rows.where((r) => r[1] != null).map((r) => _dignityRow(r[0] as String, r[1] as String)),
        if (verdict != null) ...[const SizedBox(height: 6),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.08), borderRadius: BorderRadius.circular(6)),
            child: Row(children: [const Text('VERDICT', style: TextStyle(color: AppColors.smoke, fontSize: 8, fontFamily: 'monospace')),
              const Spacer(), Text(verdict.toString().toUpperCase(), style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700))]))],
        if (notes != null) ...[const SizedBox(height: 4),
          Text(notes, style: const TextStyle(color: AppColors.lavender, fontSize: 9, fontStyle: FontStyle.italic), maxLines: 3)],
      ]));
  }

  Widget _dignityRow(String planet, String dignity) {
    final dl = dignity.toLowerCase();
    final c = dl.contains('exalt') || dl.contains('moolatrikona') ? AppColors.success
        : dl.contains('own') || dl.contains('swakshetra') ? AppColors.gold
        : dl.contains('friend') ? AppColors.aurora
        : dl.contains('neech') || dl.contains('enemy') ? AppColors.error : AppColors.smoke;
    return Container(padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0x0DFFFFFF)))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(planet, style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'serif')),
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: c.withOpacity(0.15), borderRadius: BorderRadius.circular(4), border: Border.all(color: c.withOpacity(0.4))),
          child: Text(dignity.toUpperCase(), style: TextStyle(color: c, fontSize: 8, fontFamily: 'monospace', fontWeight: FontWeight.w700))),
      ]));
  }

  // ═══ BUSINESS YOGAS ═══
  Widget _yogas(Map d) {
    final gift = (d['business_gift_yogas'] as List?) ?? [];
    final test = (d['business_test_yogas'] as List?) ?? [];
    final dhana = d['dhana_yoga_present'] == true;
    final lakshmi = d['lakshmi_yoga_present'] == true;
    final raja = d['raja_yoga_present'] == true;
    final ba = d['budha_aditya_yoga_present'] == true;
    final cm = d['chandra_mangal_yoga_present'] == true;
    final all = [
      {'name': 'Dhana Yoga', 'present': dhana}, {'name': 'Lakshmi Yoga', 'present': lakshmi},
      {'name': 'Raja Yoga', 'present': raja}, {'name': 'Budha Aditya', 'present': ba},
      {'name': 'Chandra Mangal', 'present': cm},
    ];
    return Column(children: [
      _secH('Business', 'Yogas', '${gift.length + test.length + 5} KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(spacing: 6, runSpacing: 6, children: all.map((y) {
          final present = y['present'] as bool;
          final c = present ? AppColors.success : AppColors.smoke;
          return Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: c.withOpacity(present ? 0.12 : 0.06), borderRadius: BorderRadius.circular(10),
              border: Border.all(color: c.withOpacity(present ? 0.4 : 0.15))),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(present ? '✓' : '✗', style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w700)),
              const SizedBox(width: 6),
              Text(y['name'] as String, style: TextStyle(color: c, fontSize: 10, fontWeight: present ? FontWeight.w700 : FontWeight.normal)),
            ]));
        }).toList())),
    ]);
  }

  // ═══ RECOMMENDED DOMAINS ═══
  Widget _domains(Map d) {
    final list = (d['recommended_business_types'] as List?) ?? [];
    if (list.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      _secH('Recommended', 'Domains', 'TOP ${list.length}'),
      ...list.take(5).asMap().entries.map((e) {
        final i = e.key; final item = (e.value as Map).cast<String, dynamic>();
        final domain = _tc(item['domain']?.toString() ?? '');
        final score = (item['score'] as num?)?.toDouble() ?? 0;
        final isTop = i == 0;
        return Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: isTop ? LinearGradient(colors: [AppColors.gold.withOpacity(0.12), AppColors.saffron.withOpacity(0.06)]) : null,
            color: isTop ? null : const Color(0xFF1A1642).withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isTop ? AppColors.gold.withOpacity(0.4) : AppColors.gold.withOpacity(0.15))),
          child: Row(children: [
            Container(width: 28, height: 28,
              decoration: BoxDecoration(
                gradient: isTop ? const LinearGradient(colors: [AppColors.gold, AppColors.saffron]) : null,
                color: isTop ? null : Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8)),
              child: Center(child: Text('${i + 1}', style: TextStyle(
                color: isTop ? AppColors.midnight : AppColors.smoke, fontSize: 12, fontWeight: FontWeight.w700)))),
            const SizedBox(width: 10),
            Expanded(child: Text(domain, style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w600))),
            Column(children: [
              Text(score.toStringAsFixed(1), style: TextStyle(color: isTop ? AppColors.gold : AppColors.lavender, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'serif')),
              const Text('AFFINITY', style: TextStyle(color: AppColors.smoke, fontSize: 7, fontFamily: 'monospace')),
            ]),
          ]));
      }),
    ]);
  }

  // ═══ BUSINESS STYLE ═══
  Widget _businessStyle(Map d) {
    final rows = [
      ['SERVICE VS PRODUCT', d['service_vs_product_orientation']],
      ['B2B VS B2C', d['b2b_vs_b2c_signature']],
      ['TECH VS TRADITIONAL', d['tech_vs_traditional_signature']],
      ['LEADERSHIP STYLE', d['leadership_style']],
      ['PARTNERSHIP MODE', d['solo_vs_partnership_signature']],
    ].where((r) => r[1] != null).toList();
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      _secH('Business', 'Style', '${rows.length} KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.gold.withOpacity(0.15))),
        child: Column(children: rows.map((r) => Container(padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0x0DFFFFFF)))),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(r[0] as String, style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontFamily: 'monospace')),
            Flexible(child: Text(_tc(r[1].toString()), textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w600))),
          ]))).toList())),
    ]);
  }

  // ═══ FOUNDER SKILLS ═══
  Widget _founderSkills(Map d) {
    final skills = [
      ['Strategic Thinking', _n(d, 'strategic_thinking_score')],
      ['Execution Capacity', _n(d, 'execution_capacity_score')],
      ['People Management', _n(d, 'people_management_score')],
      ['Sales & Persuasion', _n(d, 'sales_persuasion_score')],
      ['Financial Acumen', _n(d, 'financial_acumen_score')],
      ['Operational Discipline', _n(d, 'operational_discipline_score')],
    ].where((s) => (s[1] as double) > 0).toList();
    if (skills.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      _secH('Founder', 'Skills', '${skills.length} KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
        child: Column(children: skills.map((s) {
          final v = s[1] as double;
          final c = v >= 70 ? AppColors.success : v >= 55 ? AppColors.gold : AppColors.warning;
          return Padding(padding: const EdgeInsets.only(bottom: 8), child: Column(children: [
            Row(children: [Expanded(child: Text(s[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 10))),
              Text(v.toStringAsFixed(1), style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'monospace'))]),
            const SizedBox(height: 3),
            ClipRRect(borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(value: v / 100, minHeight: 4, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c))),
          ]));
        }).toList())),
    ]);
  }

  // ═══ FUNDING PROFILE ═══
  Widget _funding(Map d) {
    final sig = d['bootstrap_vs_funded_signature']?.toString() ?? '';
    final inv = _n(d, 'investor_attraction_score');
    final family = _n(d, 'family_wealth_backing_score');
    final hybrid = _n(d, 'hybrid_career_business_viability_score');
    if (sig.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      _secH('Funding', 'Profile', '5 KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.aurora.withOpacity(0.12), const Color(0xFF4A3B8C).withOpacity(0.1)]),
          borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.aurora.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('RECOMMENDED PATH', style: TextStyle(color: AppColors.aurora, fontSize: 8, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(_tc(sig), style: const TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'serif')),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _mini(inv, 'INVESTOR\nATTRACT'), _mini(family, 'FAMILY\nBACKING'), _mini(hybrid, 'HYBRID\nVIABILITY'),
          ]),
        ])),
    ]);
  }

  // ═══ TIMING WINDOWS ═══
  Widget _timing(Map d) {
    final launch = (d['entrepreneurship_launch_windows'] as List?) ?? [];
    final scale = (d['scale_growth_windows'] as List?) ?? [];
    if (launch.isEmpty && scale.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      _secH('Timing', 'Windows', '${launch.length + scale.length} ENTRIES'),
      ...launch.take(3).map((w) => _windowCard(w, 'Launch Window', '→', AppColors.aurora)),
      ...scale.take(3).map((w) => _windowCard(w, 'Scale Window', '★', AppColors.gold)),
    ]);
  }

  Widget _windowCard(dynamic w, String title, String icon, Color c) {
    if (w is! Map) return const SizedBox.shrink();
    final m = w.cast<String, dynamic>();
    return Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withOpacity(0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Text(title, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'serif')),
          const Spacer(), Text(icon, style: TextStyle(color: c, fontSize: 14))]),
        const SizedBox(height: 4),
        Text(m['dasha']?.toString() ?? '', style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w700)),
        Text(m['window']?.toString() ?? '', style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontFamily: 'monospace')),
        if (m['note'] != null) Text(m['note'].toString(), style: const TextStyle(color: AppColors.lavender, fontSize: 9, fontStyle: FontStyle.italic)),
      ]));
  }

  // ═══ RISKS ═══
  Widget _risks(Map d) {
    final burnout = _n(d, 'burnout_risk_score'); final financial = _n(d, 'financial_loss_risk_score');
    final team = _n(d, 'team_conflict_risk_score'); final legal = _n(d, 'legal_regulatory_risk_score');
    final recovery = _n(d, 'failure_recovery_capacity_score');
    return Column(children: [
      _secH('Business', 'Risks', '5 KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.warning.withOpacity(0.2))),
        child: Column(children: [
          _riskBar('Financial Loss', financial), _riskBar('Burnout', burnout),
          _riskBar('Team Conflict', team), _riskBar('Legal/Regulatory', legal),
          const SizedBox(height: 6),
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.08), borderRadius: BorderRadius.circular(6)),
            child: Row(children: [const Text('RECOVERY CAPACITY', style: TextStyle(color: AppColors.success, fontSize: 8, fontFamily: 'monospace')),
              const Spacer(), Text('${recovery.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.success, fontSize: 13, fontWeight: FontWeight.w700))])),
        ])),
    ]);
  }

  Widget _riskBar(String label, double v) {
    final c = v >= 60 ? AppColors.error : v >= 40 ? AppColors.warning : AppColors.success;
    return Padding(padding: const EdgeInsets.only(bottom: 6), child: Column(children: [
      Row(children: [Text(label, style: const TextStyle(color: AppColors.ivory, fontSize: 10)),
        const Spacer(), Text('${v.toStringAsFixed(0)}', style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'monospace'))]),
      const SizedBox(height: 2),
      ClipRRect(borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(value: v / 100, minHeight: 4, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c))),
    ]));
  }

  // ═══ REMEDIES ═══
  Widget _remedies(Map d) {
    final astro = (d['astrological_remedies'] as List?) ?? [];
    final practical = (d['practical_solutions'] as List?) ?? [];
    if (astro.isEmpty && practical.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      _secH('Remedies &', 'Solutions', '${astro.length + practical.length} KEYS'),
      ...astro.take(4).map((r) => Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gold.withOpacity(0.2))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 32, height: 32, decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppColors.gold, AppColors.saffron]), borderRadius: BorderRadius.circular(8)),
            child: const Center(child: Text('ॐ', style: TextStyle(color: AppColors.midnight, fontSize: 14, fontWeight: FontWeight.w700)))),
          const SizedBox(width: 10),
          Expanded(child: Text(r.toString(), style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.4))),
        ]))),
      if (practical.isNotEmpty) ...[
        Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
          child: Text('PRACTICAL SOLUTIONS', style: TextStyle(color: AppColors.aurora, fontSize: 9, letterSpacing: 1.5, fontFamily: 'monospace', fontWeight: FontWeight.w600))),
        ...practical.take(4).map((p) => Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.aurora.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
          child: Text(p.toString(), style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.4)))),
      ],
    ]);
  }

  // ═══ CONFIDENCE ═══
  Widget _confidence(Map d) {
    final raw = (d['confidence_score'] as num?)?.toDouble() ?? 0;
    final pct = raw <= 1.0 ? raw * 100 : raw;
    final stmt = d['plain_statement']?.toString() ?? '';
    final bd = (d['confidence_breakdown'] as Map?)?.cast<String, dynamic>() ?? {};
    return Column(children: [
      _secH('Analysis', 'Confidence', 'QUALITY'),
      Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 12), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.aurora.withOpacity(0.12), const Color(0xFF4A3B8C).withOpacity(0.15)]),
          borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.aurora.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            SizedBox(width: 70, height: 70, child: Stack(alignment: Alignment.center, children: [
              SizedBox(width: 70, height: 70, child: CircularProgressIndicator(value: pct / 100, strokeWidth: 5,
                backgroundColor: Colors.white10, valueColor: const AlwaysStoppedAnimation(AppColors.aurora))),
              Text('${pct.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.aurora, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'serif')),
            ])),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('CONFIDENCE', style: TextStyle(color: AppColors.aurora, fontSize: 8, letterSpacing: 2, fontFamily: 'monospace')),
              Text(pct >= 70 ? 'High reliability' : pct >= 50 ? 'Moderate reliability' : 'Lower — guidance only',
                style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'serif')),
            ])),
          ]),
          if (stmt.isNotEmpty) ...[const SizedBox(height: 8), Text(stmt, style: const TextStyle(color: AppColors.lavender, fontSize: 10, height: 1.5))],
          if (bd.isNotEmpty) ...[const SizedBox(height: 10),
            ...bd.entries.where((e) => e.value is Map).take(6).map((e) {
              final v = ((e.value as Map)['strength'] as num?)?.toDouble() ?? 0;
              return Padding(padding: const EdgeInsets.only(bottom: 4), child: Column(children: [
                Row(children: [Text(e.key.toUpperCase(), style: const TextStyle(color: AppColors.lavender, fontSize: 9)),
                  const Spacer(), Text('${v.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.gold, fontSize: 9, fontFamily: 'monospace', fontWeight: FontWeight.w700))]),
                ClipRRect(borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(value: v / 100, minHeight: 3, backgroundColor: Colors.white10, valueColor: const AlwaysStoppedAnimation(AppColors.aurora))),
              ]));
            })],
        ])),
    ]);
  }

  // ═══ AI BAR ═══
  Widget _aiBar(Map d) {
    return Container(margin: const EdgeInsets.fromLTRB(16, 16, 16, 8), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [const Color(0xFF1A1642).withOpacity(0.8), const Color(0xFF0A0A24)]),
        borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.gold.withOpacity(0.25))),
      child: Column(children: [
        _label('★ DISCUSS THIS REPORT WITH AI ★'), const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _aiBtn('G', 'ChatGPT', const LinearGradient(colors: [Color(0xFF10A37F), Color(0xFF1A7F64)]), () => _launchAi(d, 'chatgpt'))),
          const SizedBox(width: 8),
          Expanded(child: _aiBtn('C', 'Claude', const LinearGradient(colors: [Color(0xFFD97757), Color(0xFFB85B3F)]), () => _launchAi(d, 'claude'))),
          const SizedBox(width: 8),
          Expanded(child: _aiBtn('✦', 'Gemini', const LinearGradient(colors: [Color(0xFF4285F4), Color(0xFF9B72CB)]), () => _launchAi(d, 'gemini'))),
        ]),
        const SizedBox(height: 10),
        GestureDetector(onTap: () { Clipboard.setData(ClipboardData(text: _prompt(d)));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report copied!'))); },
          child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.copy, size: 14, color: AppColors.smoke), SizedBox(width: 6),
              Text('Copy full report data', style: TextStyle(color: AppColors.smoke, fontSize: 10))]))),
      ]));
  }

  Widget _aiBtn(String icon, String name, Gradient g, VoidCallback onTap) => GestureDetector(onTap: onTap,
    child: Container(padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withOpacity(0.2))),
      child: Column(children: [
        Container(width: 26, height: 26, decoration: BoxDecoration(gradient: g, borderRadius: BorderRadius.circular(8)),
          child: Center(child: Text(icon, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)))),
        const SizedBox(height: 5), Text(name, style: const TextStyle(color: AppColors.ivory, fontSize: 9, fontWeight: FontWeight.w700)),
        const Text('OPEN ↗', style: TextStyle(color: AppColors.smoke, fontSize: 7, fontFamily: 'monospace')),
      ])));

  String _prompt(Map d) {
    final j = const JsonEncoder.withIndent('  ').convert(d);
    return 'You are a Vedic business advisor. Analyze this business report for ${widget.chartName}.\n\n'
        'Overall: ${d['overall_business_strength_score'] ?? "?"}/100\nArchetype: ${d['founder_archetype'] ?? ""}\n'
        'Verdict: ${d['overall_business_verdict'] ?? ""}\n\nFull JSON:\n$j\n\nExplain key findings and suggest next steps.';
  }

  Future<void> _launchAi(Map d, String ai) async {
    await Clipboard.setData(ClipboardData(text: _prompt(d)));
    final urls = {'chatgpt': 'https://chat.openai.com/', 'claude': 'https://claude.ai/new', 'gemini': 'https://gemini.google.com/app'};
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied! Opening $ai...'), duration: const Duration(seconds: 3)));
    final uri = Uri.parse(urls[ai]!); if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  // ═══ HELPERS ═══
  double _n(Map d, String k) => (d[k] as num?)?.toDouble() ?? 0;
  static String _tc(String s) => s.replaceAll('_', ' ').replaceAll('-', ' ').split(' ')
      .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

  Widget _ring(double v, String label, Color c) => Column(children: [
    SizedBox(width: 76, height: 76, child: Stack(alignment: Alignment.center, children: [
      SizedBox(width: 76, height: 76, child: CircularProgressIndicator(value: v / 100, strokeWidth: 6,
        backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c))),
      Text(v.toStringAsFixed(1), style: TextStyle(color: c, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'serif')),
    ])), const SizedBox(height: 6),
    Text(label, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.smoke, fontSize: 8, letterSpacing: 1, fontFamily: 'monospace', height: 1.2)),
  ]);

  Widget _mini(double v, String label) => Column(children: [
    Text(v.toStringAsFixed(1), style: const TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'serif')),
    Text(label, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.smoke, fontSize: 7, fontFamily: 'monospace', height: 1.2)),
  ]);

  Widget _label(String text) => Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Container(width: 16, height: 1, color: AppColors.gold.withOpacity(0.4)), const SizedBox(width: 6),
    Text(text, style: const TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
    const SizedBox(width: 6), Container(width: 16, height: 1, color: AppColors.gold.withOpacity(0.4)),
  ]);

  Widget _secH(String p, String s, String tag) => Container(padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text.rich(TextSpan(children: [
        TextSpan(text: '$p ', style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'serif')),
        TextSpan(text: s, style: const TextStyle(color: AppColors.gold, fontSize: 15, fontStyle: FontStyle.italic, fontFamily: 'serif')),
      ])),
      Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.gold.withOpacity(0.15))),
        child: Text(tag, style: const TextStyle(color: AppColors.smoke, fontSize: 8, letterSpacing: 1.5, fontFamily: 'monospace'))),
    ]));
}

