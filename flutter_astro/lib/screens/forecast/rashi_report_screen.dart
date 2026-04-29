import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../specialist/report_components.dart';

class RashiReportScreen extends StatefulWidget {
  final String? chartId, chartName;
  const RashiReportScreen({super.key, this.chartId, this.chartName});
  @override
  State<RashiReportScreen> createState() => _S();
}

class _S extends State<RashiReportScreen> {
  final _api = ApiService();
  Map<String, dynamic>? _d;
  bool _loading = true;
  String? _error;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final r = await _api.getRashiAnalysis(chartId: widget.chartId);
      if (!mounted) return;
      if (r['statusCode'] == 200 && r['status'] == 'success')
        setState(() { _d = (r['data'] as Map).cast<String, dynamic>(); _loading = false; });
      else setState(() { _error = r['detail']?.toString() ?? 'Failed'; _loading = false; });
    } catch (e) { if (!mounted) return; setState(() { _error = e.toString(); _loading = false; }); }
  }

  static const _rashiEmojis = {'Aries': '♈', 'Taurus': '♉', 'Gemini': '♊', 'Cancer': '♋', 'Leo': '♌', 'Virgo': '♍',
    'Libra': '♎', 'Scorpio': '♏', 'Sagittarius': '♐', 'Capricorn': '♑', 'Aquarius': '♒', 'Pisces': '♓'};
  static const _rashiColors = [Colors.red, Colors.green, Colors.amber, Colors.blue,
    Colors.orange, Colors.teal, Colors.pink, Colors.deepOrange, Colors.purple,
    Colors.brown, Colors.cyan, Colors.indigo];

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFF0A0A24),
      body: _loading ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _error != null ? _errV() : _d != null ? _report() : const SizedBox.shrink());
  }

  Widget _errV() => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    const Icon(Icons.error_outline, color: AppColors.error, size: 48), const SizedBox(height: 12),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(_error!, style: const TextStyle(color: AppColors.smoke), textAlign: TextAlign.center)),
    const SizedBox(height: 16), ElevatedButton(onPressed: _load, child: const Text('Retry')),
  ]));

  Widget _report() {
    final d = _d!;
    final mode = d['mode']?.toString() ?? 'standalone';
    // rashis is a DICT keyed by '1_mesha', '2_vrishabha', etc.
    final rashisRaw = d['rashis'];
    final rashiEntries = <MapEntry<String, Map<String, dynamic>>>[];
    if (rashisRaw is Map) {
      rashisRaw.forEach((k, v) {
        if (v is Map) rashiEntries.add(MapEntry(k.toString(), v.cast<String, dynamic>()));
      });
    }

    return CustomScrollView(slivers: [
      SliverAppBar(backgroundColor: const Color(0xFF0A0A24), pinned: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory), onPressed: () => Navigator.pop(context)),
        title: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
          if (widget.chartName != null) Text(widget.chartName!.toUpperCase(), style: const TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 1.5, fontFamily: 'monospace')),
          const Text.rich(TextSpan(children: [
            TextSpan(text: '12 Rashi ', style: TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w600)),
            TextSpan(text: 'Report', style: TextStyle(color: AppColors.gold, fontSize: 18, fontStyle: FontStyle.italic)),
          ])),
        ]),
        centerTitle: true, actions: [IconButton(icon: const Icon(Icons.refresh, color: AppColors.ivory, size: 18), onPressed: _load)]),
      SliverList(delegate: SliverChildListDelegate([
        // Banner
        Container(margin: const EdgeInsets.fromLTRB(16, 12, 16, 12), padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.12), const Color(0xFF4A3B8C).withOpacity(0.15)]),
            borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.gold.withOpacity(0.25))),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(width: 16, height: 1, color: AppColors.gold.withOpacity(0.4)), const SizedBox(width: 6),
              Text('${mode == 'personalized' ? "★ PERSONALIZED" : "☉ CLASSICAL"} · 12 RASHIS',
                style: const TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
              const SizedBox(width: 6), Container(width: 16, height: 1, color: AppColors.gold.withOpacity(0.4)),
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _stat('12', 'RASHIS'), _stat('14', 'SEC/RASHI'), _stat(mode == 'personalized' ? 'CHART' : 'CLASSIC', 'MODE'),
            ]),
          ])),
        // Rashi grid
        Container(padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Wrap(spacing: 8, runSpacing: 8, children: rashiEntries.toList().asMap().entries.map((e) {
            final i = e.key;
            final r = e.value.value;
            final engName = r['rashi_name_english']?.toString() ?? '';
            final sanName = r['rashi_name_sanskrit']?.toString() ?? '';
            final symbol = r['rashi_glyph']?.toString() ?? _rashiEmojis[engName] ?? '★';
            final lord = r['swami_lord']?.toString() ?? '';
            final sig = r['rashi_signature']?.toString() ?? '';
            final color = i < _rashiColors.length ? _rashiColors[i] : AppColors.gold;
            return GestureDetector(
              onTap: () => _showDetail(engName.isNotEmpty ? engName : sanName, symbol, color, r),
              child: SizedBox(width: (MediaQuery.of(context).size.width - 40) / 2,
                child: Container(padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [color.withOpacity(0.10), const Color(0xFF1A1642).withOpacity(0.5)]),
                    borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.25))),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Text('${(i + 1).toString().padLeft(2, '0')}', style: TextStyle(color: color.withOpacity(0.5), fontSize: 9, fontFamily: 'monospace')),
                      const Spacer(), Text(symbol, style: const TextStyle(fontSize: 20)),
                    ]),
                    const SizedBox(height: 6),
                    Text(engName.isNotEmpty ? engName : sanName, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'serif')),
                    if (sanName.isNotEmpty && engName.isNotEmpty) Text(sanName, style: const TextStyle(color: AppColors.smoke, fontSize: 8)),
                    Text('Lord: $lord', style: const TextStyle(color: AppColors.smoke, fontSize: 8, fontFamily: 'monospace')),
                    if (sig.isNotEmpty) ...[const SizedBox(height: 4),
                      Text(sig, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: color.withOpacity(0.7), fontSize: 8, fontStyle: FontStyle.italic, height: 1.3))],
                  ]))));
          }).toList())),
        const SizedBox(height: 30),
      ])),
    ]);
  }

  void _showDetail(String name, String emoji, Color color, Map<String, dynamic> r) {
    showModalBottomSheet(context: context, isScrollControlled: true,
      backgroundColor: const Color(0xFF0A0A24),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85, minChildSize: 0.4, maxChildSize: 0.95, expand: false,
        builder: (_, sc) => ListView(controller: sc, padding: const EdgeInsets.all(16), children: [
          Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
          Text('$emoji $name', style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'serif')),
          const SizedBox(height: 12),
          ...r.entries.where((e) => !{'rashi_name_english', 'rashi_name_sanskrit', 'rashi_glyph', 'rashi_number'}.contains(e.key)).map((e) {
            if (e.value is String && (e.value as String).isNotEmpty) return _row(e.key, e.value.toString(), color);
            if (e.value is num) return _row(e.key, e.value.toString(), color);
            if (e.value is List && (e.value as List).isNotEmpty) return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 8),
              Text(_tc(e.key), style: TextStyle(color: color, fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
              ...(e.value as List).take(6).map((item) => Padding(padding: const EdgeInsets.only(left: 8, top: 3),
                child: Text('• ${item is Map ? (item as Map).values.join(" · ") : item}',
                  style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.3)))),
            ]);
            if (e.value is Map) return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 8),
              Text(_tc(e.key), style: TextStyle(color: color, fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
              ...(e.value as Map).entries.where((x) => x.value is String || x.value is num).take(8).map((x) =>
                _row(x.key, x.value.toString(), color)),
            ]);
            return const SizedBox.shrink();
          }),
        ])));
  }

  Widget _row(String k, String v, Color c) => Padding(padding: const EdgeInsets.only(bottom: 4),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 90, child: Text(_tc(k), style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontFamily: 'monospace'))),
      Expanded(child: Text(v, style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.3))),
    ]));

  Widget _stat(String num, String label) => Column(children: [
    Text(num, style: const TextStyle(color: AppColors.gold, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'serif')),
    Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 7, fontFamily: 'monospace', letterSpacing: 1)),
  ]);

  static String _tc(String s) => s.replaceAll('_', ' ').split(' ')
    .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
}
