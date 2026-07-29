import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../utils/kundli_names.dart';
import '../kundli/widgets/kundli_ui.dart';
import 'rashi_detail_screen.dart';
import 'rashi_shared.dart';

/// Home → Rashi: a modern zodiac dashboard.
///
/// Presentation only. Reads `/rashi/today` (unchanged) and converts the raw
/// gochar scores into positive 0–100 energy for display; no scoring, transit
/// or astrology logic is altered.
class RashiListScreen extends StatefulWidget {
  const RashiListScreen({super.key});
  @override
  State<RashiListScreen> createState() => _RashiListScreenState();
}

class _RashiListScreenState extends State<RashiListScreen> {
  final _api = ApiService();
  List<Map<String, dynamic>> _rashis = const [];
  String? _date, _best, _worst;
  bool _loading = true;
  String? _error;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final resp = await _api.getRashiToday();
      if (!mounted) return;
      if (resp['statusCode'] == 200 && resp['status'] == 'success') {
        final data = (resp['data'] as Map).cast<String, dynamic>();
        setState(() {
          _date = data['date']?.toString();
          _best = data['best']?.toString();
          _worst = data['worst']?.toString();
          _rashis = ((data['rashis'] as List?) ?? []).map((e) => (e as Map).cast<String, dynamic>()).toList();
          _loading = false;
        });
      } else {
        setState(() { _error = resp['detail']?.toString() ?? 'Failed'; _loading = false; });
      }
    } catch (e) { if (!mounted) return; setState(() { _error = e.toString(); _loading = false; }); }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(l.rashi, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
        actions: [IconButton(onPressed: _load, icon: const Icon(Icons.refresh))],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _error != null ? _errView(l)
          : RefreshIndicator(
              onRefresh: _load, color: AppColors.gold, backgroundColor: AppColors.card,
              child: ListView(padding: const EdgeInsets.fromLTRB(14, 12, 14, 30), children: [
                KFadeIn(child: _hero(l)),
                const SizedBox(height: 18),
                KFadeIn(delayMs: 80, child: Row(children: [
                  const Icon(Icons.grid_view_rounded, size: 16, color: AppColors.gold), const SizedBox(width: 8),
                  Text(l.rzAllSigns, style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w800)),
                ])),
                const SizedBox(height: 12),
                _grid(l),
              ]),
            ),
    );
  }

  // ── hero ──────────────────────────────────────────────────────────
  Widget _hero(AppLocalizations l) {
    final energies = _rashis.map((z) => RashiUi.energy((z['score'] as num?)?.toDouble() ?? 0)).toList();
    final avg = energies.isEmpty ? 50.0 : energies.reduce((a, b) => a + b) / energies.length;
    final moodCol = RashiUi.energyColor(avg);
    final mood = avg >= 65 ? l.rzMoodBright : avg >= 50 ? l.rzMoodCalm : avg >= 38 ? l.rzMoodMixed : l.rzMoodTense;
    // dominant = lord of the highest-scoring sign; challenging = lord of lowest.
    Map<String, dynamic>? topZ, lowZ;
    for (final z in _rashis) {
      final s = (z['score'] as num?)?.toDouble() ?? 0;
      if (topZ == null || s > ((topZ['score'] as num?)?.toDouble() ?? -99)) topZ = z;
      if (lowZ == null || s < ((lowZ['score'] as num?)?.toDouble() ?? 99)) lowZ = z;
    }
    final loc = Localizations.localeOf(context);
    final domPlanet = KundliNames.planet(topZ?['lord']?.toString() ?? '', loc);
    final chalPlanet = KundliNames.planet(lowZ?['lord']?.toString() ?? '', loc);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [moodCol.withOpacity(0.18), AppColors.card.withOpacity(0.45)]),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: moodCol.withOpacity(0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('🌌', style: TextStyle(fontSize: 18)), const SizedBox(width: 8),
          Text(l.rzTodayOutlook, style: const TextStyle(color: AppColors.ivory, fontSize: 15.5, fontWeight: FontWeight.w800)),
          const Spacer(),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: moodCol.withOpacity(0.16), borderRadius: BorderRadius.circular(20)),
            child: Text(mood, style: TextStyle(color: moodCol, fontSize: 11, fontWeight: FontWeight.w800))),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: _heroStat('⭐', l.rzBestSign, RashiUi.signName(_best, l), KColors.green)),
          const SizedBox(width: 10),
          Expanded(child: _heroStat('⚠️', l.rzChallengingSign, RashiUi.signName(_worst, l), KColors.orange)),
        ]),
        const SizedBox(height: 10),
        _heroStat('🪐', l.rzDominantPlanet, domPlanet, AppColors.gold),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: AppColors.midnight.withOpacity(0.35), borderRadius: BorderRadius.circular(14)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('🤖', style: TextStyle(fontSize: 14)), const SizedBox(width: 9),
            Expanded(child: Text(l.rzHomeSummary(domPlanet, chalPlanet), style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, height: 1.5))),
          ]),
        ),
      ]),
    );
  }

  Widget _heroStat(String emoji, String label, String value, Color c) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: c.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.22))),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 16)), const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w600)),
        Text(value, style: const TextStyle(color: AppColors.ivory, fontSize: 13.5, fontWeight: FontWeight.w800)),
      ])),
    ]),
  );

  // ── grid ──────────────────────────────────────────────────────────
  Widget _grid(AppLocalizations l) => GridView.builder(
    shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.86),
    itemCount: _rashis.length,
    itemBuilder: (_, i) => KFadeIn(delayMs: (i * 40).clamp(0, 400), child: _card(l, _rashis[i], i)),
  );

  Widget _card(AppLocalizations l, Map<String, dynamic> z, int i) {
    final loc = Localizations.localeOf(context);
    final idx = (z['idx'] as num?)?.toInt() ?? i;
    final energy = RashiUi.energy((z['score'] as num?)?.toDouble() ?? 0);
    final col = RashiUi.energyColor(energy);
    final lord = z['lord']?.toString() ?? '';
    final insight = energy >= 50 ? l.rzInsightGood(RashiUi.karaka(lord, l)) : l.rzInsightHard(RashiUi.karaka(lord, l));
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => RashiDetailScreen(rashiIdx: idx, initialName: z['name']?.toString()))),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [col.withOpacity(0.14), AppColors.card.withOpacity(0.5)]),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: col.withOpacity(0.28)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(z['emoji']?.toString() ?? '', style: const TextStyle(fontSize: 24)),
            const Spacer(),
            _statusBadge(RashiUi.energyStatus(energy, l), col),
          ]),
          const SizedBox(height: 8),
          Text(RashiUi.signName(z['name']?.toString(), l), style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text('${z['sanskrit'] ?? ''} · ${z['element'] ?? ''} · ${KundliNames.planet(lord, loc)}',
            style: const TextStyle(color: AppColors.smoke, fontSize: 9.5), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 10),
          Row(children: [
            Text(energy.toStringAsFixed(0), style: TextStyle(color: col, fontSize: 22, fontWeight: FontWeight.w800, height: 1)),
            Text('/100', style: TextStyle(color: col.withOpacity(0.6), fontSize: 10, fontWeight: FontWeight.w600)),
            const Spacer(),
            Text(l.rzTodayEnergy, style: const TextStyle(color: AppColors.smoke, fontSize: 8.5)),
          ]),
          const SizedBox(height: 5),
          ClipRRect(borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: (energy / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
          const Spacer(),
          Text('💡 $insight', style: const TextStyle(color: AppColors.parchment, fontSize: 10, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
        ]),
      ),
    );
  }

  Widget _statusBadge(String text, Color c) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: c.withOpacity(0.16), borderRadius: BorderRadius.circular(8)),
    child: Text(text, style: TextStyle(color: c, fontSize: 9, fontWeight: FontWeight.w800)),
  );

  Widget _errView(AppLocalizations l) => Center(child: Padding(padding: const EdgeInsets.all(24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.error_outline, color: AppColors.error, size: 40), const SizedBox(height: 12),
      Text(_error!, style: const TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
      const SizedBox(height: 12), ElevatedButton(onPressed: _load, child: Text(l.retry)),
    ])));
}
