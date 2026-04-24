import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

class MilanViewerScreen extends StatefulWidget {
  final String chartId1, chartId2, name1, name2;
  const MilanViewerScreen({super.key, required this.chartId1, required this.chartId2,
    required this.name1, required this.name2});

  @override
  State<MilanViewerScreen> createState() => _MilanViewerScreenState();
}

class _MilanViewerScreenState extends State<MilanViewerScreen> with TickerProviderStateMixin {
  final _api = ApiService();
  late final TabController _tabs;
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  static const _tabLabels = ['Overview', 'Ashtakoot', 'Doshas', 'Advanced', 'Timing'];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: _tabLabels.length, vsync: this);
    _load();
  }

  @override
  void dispose() { _tabs.dispose(); super.dispose(); }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final resp = await _api.milanFullMatch(widget.chartId1, widget.chartId2);
      if (!mounted) return;
      if (resp['statusCode'] == 200 && resp['status'] == 'success') {
        setState(() { _data = (resp['data'] as Map).cast<String, dynamic>(); _loading = false; });
      } else {
        setState(() { _error = resp['detail']?.toString() ?? 'Analysis failed'; _loading = false; });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text('${widget.name1} & ${widget.name2}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
          const Text('Kundli Milan', style: TextStyle(color: AppColors.primary, fontSize: 11)),
        ]),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _load)],
        bottom: TabBar(
          controller: _tabs, isScrollable: true,
          labelColor: AppColors.primary, unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: _tabLabels.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _error != null
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                  const SizedBox(height: 12),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(_error!, style: const TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center)),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _load, child: const Text('Retry')),
                ]))
              : TabBarView(controller: _tabs, children: [
                  _OverviewTab(data: _data!),
                  _AshtakootTab(phase1: (_data!['phase1'] as Map?)?.cast<String, dynamic>() ?? {}),
                  _DoshaTab(phase1: (_data!['phase1'] as Map?)?.cast<String, dynamic>() ?? {},
                            phase2: (_data!['phase2'] as Map?)?.cast<String, dynamic>() ?? {}),
                  _AdvancedTab(phase2: (_data!['phase2'] as Map?)?.cast<String, dynamic>() ?? {}),
                  _TimingTab(phase3: (_data!['phase3'] as Map?)?.cast<String, dynamic>() ?? {}),
                ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// TAB 1: OVERVIEW
// ═══════════════════════════════════════════════════════════════════
class _OverviewTab extends StatelessWidget {
  final Map<String, dynamic> data;
  const _OverviewTab({required this.data});

  @override
  Widget build(BuildContext context) {
    final unified = (data['unified'] as Map?)?.cast<String, dynamic>() ?? {};
    final phase1 = (data['phase1'] as Map?)?.cast<String, dynamic>() ?? {};
    final phase2 = (data['phase2'] as Map?)?.cast<String, dynamic>() ?? {};
    final phase3 = (data['phase3'] as Map?)?.cast<String, dynamic>() ?? {};
    final score = (unified['unified_score'] as num?)?.toDouble() ?? 0;
    final grade = unified['grade']?.toString() ?? '';
    final stars = unified['stars']?.toString() ?? '';
    final verdict = unified['marriage_verdict']?.toString() ?? '';
    final components = (unified['component_scores'] as Map?)?.cast<String, dynamic>() ?? {};
    final scoreColor = score >= 70 ? Colors.green : score >= 50 ? Colors.orange : Colors.red;

    return ListView(padding: const EdgeInsets.all(16), children: [
      // Big score card
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [scoreColor.withOpacity(0.15), Colors.transparent]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: scoreColor.withOpacity(0.3)),
        ),
        child: Column(children: [
          Text(stars, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text('${score.toStringAsFixed(1)}%', style: TextStyle(color: scoreColor, fontSize: 42, fontWeight: FontWeight.w700)),
          Text(grade, style: TextStyle(color: scoreColor, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text('${phase1['total_score'] ?? 0}/36 Ashtakoot', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ]),
      ),
      if (verdict.isNotEmpty) ...[
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
          child: Text(verdict, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, height: 1.4)),
        ),
      ],
      const SizedBox(height: 14),
      // Phase scores
      _phaseRow('Ashtakoot (Phase 1)', phase1['final_probability'] as num?, Colors.blue),
      _phaseRow('Advanced (Phase 2)', phase2['phase2_score'] as num?, Colors.purple),
      _phaseRow('Timing (Phase 3)', phase3['phase3_score'] as num?, Colors.teal),
      const SizedBox(height: 14),
      // Component breakdown
      if (components.isNotEmpty) ...[
        const Text('Score Components', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...components.entries.map((e) {
          final v = (e.value as num?)?.toDouble() ?? 0;
          final label = e.key.replaceAll('_', ' ').split(' ').map((w) =>
              w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
          return Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [
            Expanded(child: Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 11))),
            SizedBox(width: 80, child: ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: v / 100, minHeight: 5,
                backgroundColor: Colors.white12, valueColor: AlwaysStoppedAnimation(
                  v >= 70 ? Colors.green : v >= 50 ? Colors.orange : Colors.red)))),
            const SizedBox(width: 8),
            SizedBox(width: 32, child: Text('${v.toStringAsFixed(0)}', textAlign: TextAlign.right,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 11))),
          ]));
        }),
      ],
    ]);
  }

  Widget _phaseRow(String label, num? score, Color color) {
    final v = score?.toDouble() ?? 0;
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
      Container(width: 4, height: 24, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 10),
      Expanded(child: Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13))),
      Text('${v.toStringAsFixed(0)}%', style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700)),
    ]));
  }
}

// ═══════════════════════════════════════════════════════════════════
// TAB 2: ASHTAKOOT (8 GUN)
// ═══════════════════════════════════════════════════════════════════
class _AshtakootTab extends StatelessWidget {
  final Map<String, dynamic> phase1;
  const _AshtakootTab({required this.phase1});

  @override
  Widget build(BuildContext context) {
    final guns = (phase1['guns'] as List?) ?? [];
    final total = (phase1['total_score'] as num?)?.toDouble() ?? 0;
    return ListView(padding: const EdgeInsets.all(16), children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          const Icon(Icons.stars, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Text('Total: ${total.toStringAsFixed(1)}/36', style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w700)),
          const Spacer(),
          Text(phase1['grade']?.toString() ?? '', style: const TextStyle(color: AppColors.primary, fontSize: 12)),
        ]),
      ),
      const SizedBox(height: 12),
      ...guns.map<Widget>((g) {
        final gun = (g as Map).cast<String, dynamic>();
        final score = (gun['score'] as num?)?.toDouble() ?? 0;
        final max = (gun['max'] as num?)?.toInt() ?? 1;
        final pct = max > 0 ? score / max : 0.0;
        final color = pct >= 0.75 ? Colors.green : pct >= 0.5 ? Colors.orange : Colors.red;
        final hasDosha = gun['has_dosha'] == true;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text('${gun['gun_num']}. ${gun['gun'] ?? ''}',
                  style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700))),
              Text('${score.toStringAsFixed(1)}/${max}',
                  style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700)),
              if (hasDosha) ...[
                const SizedBox(width: 6),
                const Icon(Icons.warning, color: Colors.red, size: 14),
              ],
            ]),
            ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: pct, minHeight: 4, backgroundColor: Colors.white12,
                valueColor: AlwaysStoppedAnimation(color))),
            const SizedBox(height: 6),
            if (gun['meaning'] != null)
              Text(gun['meaning'].toString(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
            const SizedBox(height: 4),
            Row(children: [
              _chip(gun['groom_val']?.toString() ?? '', Colors.blue),
              const SizedBox(width: 6),
              const Icon(Icons.compare_arrows, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              _chip(gun['bride_val']?.toString() ?? '', Colors.pink),
            ]),
            const SizedBox(height: 4),
            Text(gun['status']?.toString() ?? '', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
            if (gun['detail'] != null && gun['detail'].toString().isNotEmpty)
              Padding(padding: const EdgeInsets.only(top: 4),
                child: Text(gun['detail'].toString(), style: const TextStyle(color: AppColors.textPrimary, fontSize: 11))),
            if (hasDosha && gun['remedy'] != null && gun['remedy'].toString().isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(Icons.auto_fix_high, size: 12, color: Colors.orange),
                  const SizedBox(width: 6),
                  Expanded(child: Text(gun['remedy'].toString(),
                      style: const TextStyle(color: Colors.orange, fontSize: 10))),
                ])),
            ],
          ]),
        );
      }),
    ]);
  }

  Widget _chip(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
    child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
  );
}

// ═══════════════════════════════════════════════════════════════════
// TAB 3: DOSHAS
// ═══════════════════════════════════════════════════════════════════
class _DoshaTab extends StatelessWidget {
  final Map<String, dynamic> phase1, phase2;
  const _DoshaTab({required this.phase1, required this.phase2});

  @override
  Widget build(BuildContext context) {
    final activeDoshas = (phase1['active_doshas'] as List?) ?? [];
    final mangalG = (phase1['mangal_groom'] as Map?)?.cast<String, dynamic>() ?? {};
    final mangalB = (phase1['mangal_bride'] as Map?)?.cast<String, dynamic>() ?? {};
    final rajju = (phase1['rajju_dosha'] as Map?)?.cast<String, dynamic>() ?? {};
    final papa = (phase1['papasamya'] as Map?)?.cast<String, dynamic>() ?? {};
    final mangalG2 = (phase2['mangal_groom'] as Map?)?.cast<String, dynamic>() ?? {};
    final mangalB2 = (phase2['mangal_bride'] as Map?)?.cast<String, dynamic>() ?? {};
    final recs = (phase1['recommendations'] as List?) ?? [];

    return ListView(padding: const EdgeInsets.all(16), children: [
      if (activeDoshas.isNotEmpty) ...[
        Wrap(spacing: 6, runSpacing: 6, children: activeDoshas.map<Widget>((d) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: Colors.red.withOpacity(0.12), borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.red.withOpacity(0.3))),
          child: Text(d.toString(), style: const TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.w600)),
        )).toList()),
        const SizedBox(height: 14),
      ],
      _mangalCard('Mangal Dosha — Groom', mangalG, mangalG2),
      const SizedBox(height: 10),
      _mangalCard('Mangal Dosha — Bride', mangalB, mangalB2),
      const SizedBox(height: 10),
      _doshaCard('Rajju Dosha', rajju['has_rajju_dosha'] == true, [
        if (rajju['status'] != null) rajju['status'].toString(),
        if (rajju['remedy'] != null) rajju['remedy'].toString(),
      ]),
      const SizedBox(height: 10),
      _doshaCard('Papasamya (Affliction Balance)', papa['balanced'] == true, [
        papa['result']?.toString() ?? '',
        'Groom: ${papa['p1_score'] ?? 0} | Bride: ${papa['p2_score'] ?? 0}',
      ], isGood: papa['balanced'] == true),
      if (recs.isNotEmpty) ...[
        const SizedBox(height: 14),
        const Text('Recommendations', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...recs.map<Widget>((r) => Padding(padding: const EdgeInsets.only(bottom: 4),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.auto_fix_high, size: 12, color: AppColors.primary),
            const SizedBox(width: 6),
            Expanded(child: Text(r.toString(), style: const TextStyle(color: AppColors.textPrimary, fontSize: 11))),
          ]))),
      ],
    ]);
  }

  Widget _mangalCard(String title, Map<String, dynamic> m, Map<String, dynamic> m2) {
    final has = m['has_mangal_dosh'] == true;
    final severity = m['severity']?.toString() ?? 'None';
    final cancellations = (m2['cancellations'] as List?) ?? [];
    final effective = m2['has_effective_dosh'];
    final color = !has ? Colors.green : severity == 'Severe' ? Colors.red : Colors.orange;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withOpacity(0.06), borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(has ? Icons.warning : Icons.check_circle, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700))),
          Text(severity, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        ]),
        if (has) ...[
          const SizedBox(height: 6),
          Text('Mars in H${m['mars_h_lagna'] ?? "?"} (Lagna), H${m['mars_h_moon'] ?? "?"} (Moon), H${m['mars_h_venus'] ?? "?"} (Venus)',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
          if (effective == false && cancellations.isNotEmpty) ...[
            const SizedBox(height: 6),
            const Text('Cancellations:', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.w600)),
            ...cancellations.take(3).map<Widget>((c) {
              final canc = (c as Map).cast<String, dynamic>();
              return Text('  ✓ ${canc['rule']}: ${canc['desc'] ?? ''}',
                  style: const TextStyle(color: Colors.green, fontSize: 10));
            }),
          ],
        ],
        if (m['remedy'] != null && m['remedy'].toString().isNotEmpty)
          Padding(padding: const EdgeInsets.only(top: 6),
            child: Text('Remedy: ${m['remedy']}', style: const TextStyle(color: Colors.orange, fontSize: 10))),
      ]),
    );
  }

  Widget _doshaCard(String title, bool hasDosh, List<String> details, {bool isGood = false}) {
    final color = isGood ? Colors.green : hasDosh ? Colors.red : Colors.green;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withOpacity(0.06), borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(hasDosh && !isGood ? Icons.warning : Icons.check_circle, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700))),
        ]),
        ...details.where((d) => d.isNotEmpty).map<Widget>((d) => Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(d, style: const TextStyle(color: AppColors.textPrimary, fontSize: 11)),
        )),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// TAB 4: ADVANCED (Phase 2 — Navamsa, Venus, Dasha Sync)
// ═══════════════════════════════════════════════════════════════════
class _AdvancedTab extends StatelessWidget {
  final Map<String, dynamic> phase2;
  const _AdvancedTab({required this.phase2});

  @override
  Widget build(BuildContext context) {
    final nav = (phase2['navamsa'] as Map?)?.cast<String, dynamic>() ?? {};
    final venus = (phase2['venus'] as Map?)?.cast<String, dynamic>() ?? {};
    final dasha = (phase2['dasha_sync'] as Map?)?.cast<String, dynamic>() ?? {};
    final p2score = (phase2['phase2_score'] as num?)?.toDouble() ?? 0;

    return ListView(padding: const EdgeInsets.all(16), children: [
      _headerChip('Phase 2 Score', '${p2score.toStringAsFixed(0)}%', phase2['phase2_grade']?.toString() ?? ''),
      const SizedBox(height: 14),
      _factorCard('Navamsa (D-9) Compatibility', Icons.grid_view, Colors.purple,
          (nav['navamsa_score'] as num?)?.toDouble() ?? 0, nav['grade']?.toString() ?? '',
          (nav['factors'] as List?) ?? []),
      const SizedBox(height: 10),
      _factorCard('Venus Compatibility', Icons.favorite, Colors.pink,
          (venus['venus_score'] as num?)?.toDouble() ?? 0, venus['grade']?.toString() ?? '',
          (venus['factors'] as List?) ?? []),
      const SizedBox(height: 10),
      _dashaSync(dasha),
    ]);
  }

  Widget _headerChip(String label, String value, String grade) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.purple.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
    child: Row(children: [
      const Icon(Icons.insights, color: Colors.purple, size: 20),
      const SizedBox(width: 8),
      Text('$label: $value', style: const TextStyle(color: Colors.purple, fontSize: 15, fontWeight: FontWeight.w700)),
      const Spacer(),
      Text(grade, style: const TextStyle(color: Colors.purple, fontSize: 12)),
    ]),
  );

  Widget _factorCard(String title, IconData icon, Color color, double score, String grade, List factors) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withOpacity(0.1), color.withOpacity(0.03)]),
        borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.25))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700))),
          Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(width: 6),
          Text(grade, style: TextStyle(color: color, fontSize: 10)),
        ]),
        if (factors.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...factors.take(5).map<Widget>((f) {
            final fac = (f as Map).cast<String, dynamic>();
            return Padding(padding: const EdgeInsets.only(bottom: 4),
              child: Text('• ${fac['factor'] ?? ''}: ${fac['desc'] ?? ''}',
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 10)));
          }),
        ],
      ]),
    );
  }

  Widget _dashaSync(Map<String, dynamic> d) {
    final score = (d['sync_score'] as num?)?.toDouble() ?? 0;
    final syncType = d['sync_type']?.toString() ?? '';
    final color = score >= 70 ? Colors.green : score >= 45 ? Colors.orange : Colors.red;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withOpacity(0.06), borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.sync, color: color, size: 18),
          const SizedBox(width: 8),
          const Expanded(child: Text('Dasha Sync', style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700))),
          Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700)),
        ]),
        if (syncType.isNotEmpty) Text(syncType, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        if (d['timing_assessment'] != null)
          Padding(padding: const EdgeInsets.only(top: 4),
            child: Text(d['timing_assessment'].toString(), style: const TextStyle(color: AppColors.textPrimary, fontSize: 11))),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// TAB 5: TIMING (Phase 3 — Gochar, Dasha Timeline, Overlaps)
// ═══════════════════════════════════════════════════════════════════
class _TimingTab extends StatelessWidget {
  final Map<String, dynamic> phase3;
  const _TimingTab({required this.phase3});

  @override
  Widget build(BuildContext context) {
    final gochar = (phase3['gochar_windows'] as Map?)?.cast<String, dynamic>() ?? {};
    final dasha = (phase3['dasha_timeline'] as Map?)?.cast<String, dynamic>() ?? {};
    final overlaps = (phase3['overlapping_windows'] as List?) ?? [];
    final rec = phase3['recommendation']?.toString() ?? '';
    final p3score = (phase3['phase3_score'] as num?)?.toDouble() ?? 0;

    return ListView(padding: const EdgeInsets.all(16), children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.teal.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          const Icon(Icons.calendar_month, color: Colors.teal, size: 20),
          const SizedBox(width: 8),
          Text('Timing Score: ${p3score.toStringAsFixed(0)}%',
              style: const TextStyle(color: Colors.teal, fontSize: 15, fontWeight: FontWeight.w700)),
          const Spacer(),
          Text(phase3['phase3_grade']?.toString() ?? '', style: const TextStyle(color: Colors.teal, fontSize: 12)),
        ]),
      ),
      if (rec.isNotEmpty) ...[
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.lightbulb, color: AppColors.primary, size: 16),
            const SizedBox(width: 8),
            Expanded(child: Text(rec, style: const TextStyle(color: AppColors.primary, fontSize: 11))),
          ]),
        ),
      ],
      const SizedBox(height: 14),
      // Gochar windows
      if ((gochar['windows'] as List?)?.isNotEmpty == true) ...[
        const Text('Transit Marriage Windows', style: TextStyle(color: Colors.teal, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...((gochar['windows'] as List?) ?? []).take(5).map<Widget>((w) {
          final win = (w as Map).cast<String, dynamic>();
          final ws = (win['score'] as num?)?.toDouble() ?? 0;
          final isBest = win == (gochar['best_window'] as Map?);
          final color = isBest ? Colors.green : Colors.teal;
          return Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.06), borderRadius: BorderRadius.circular(8),
              border: isBest ? Border.all(color: Colors.green.withOpacity(0.4)) : null),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                if (isBest) const Icon(Icons.star, size: 14, color: Colors.green),
                Text('${win['year'] ?? ''} ${win['date'] ?? ''}', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
                const Spacer(),
                Text('${ws.toStringAsFixed(0)}%', style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700)),
              ]),
              if ((win['triggers'] as List?)?.isNotEmpty == true)
                Text((win['triggers'] as List).take(3).join(' • '),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 9)),
            ]),
          );
        }),
      ],
      // Overlapping windows
      if (overlaps.isNotEmpty) ...[
        const SizedBox(height: 14),
        const Text('Overlapping Marriage Windows', style: TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...overlaps.take(5).map<Widget>((o) {
          final ol = (o as Map).cast<String, dynamic>();
          return Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.green.withOpacity(0.06), borderRadius: BorderRadius.circular(8)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${ol['start'] ?? ''} — ${ol['end'] ?? ''}',
                  style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600)),
              Text('Groom: ${ol['groom_period'] ?? ''} | Bride: ${ol['bride_period'] ?? ''}',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
              Text('Combined: ${(ol['combined_score'] as num?)?.toStringAsFixed(0) ?? '?'}%',
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 11)),
            ]),
          );
        }),
      ],
    ]);
  }
}
