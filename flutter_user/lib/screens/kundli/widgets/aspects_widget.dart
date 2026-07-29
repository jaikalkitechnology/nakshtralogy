import 'package:flutter/material.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_service.dart';
import '../../../utils/kundli_names.dart';
import '_section_loader.dart';

/// ════════════════════════════════════════════════════════════════════
///  ASPECTS (DRISHTI) — beginner-friendly redesign
///
///  Two clearly separated systems (never mixed):
///   • Graha Drishti — planet → planet (Parashari)
///   • Rashi Drishti — sign → sign (Jaimini)
///
///  Presentation only. Aspect data comes from the corrected API
///  (graha_drishti / graha_drishti_received / lagna_aspects_received /
///  rashi_drishti / special_aspects / planet_signs).
/// ════════════════════════════════════════════════════════════════════

const List<String> _kSignsShort = [
  'Ar', 'Ta', 'Ge', 'Cn', 'Le', 'Vi', 'Li', 'Sc', 'Sg', 'Cp', 'Aq', 'Pi'
];
const List<String> _kPlanetOrder = [
  'Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn', 'Rahu', 'Ketu'
];

class AspectColors {
  static const Color graha = Color(0xFF9B7FE0); // purple  🟣
  static const Color rashi = AppColors.success; // green   🟢
  static const Color special = AppColors.gold; // gold    ⭐
  static const Color present = AppColors.success;
  static const Color absent = AppColors.smoke;
}

String _glyph(String p) {
  switch (p) {
    case 'Sun': return '☀';
    case 'Moon': return '☾';
    case 'Mars': return '♂';
    case 'Mercury': return '☿';
    case 'Jupiter': return '♃';
    case 'Venus': return '♀';
    case 'Saturn': return '♄';
    case 'Rahu': return '☊';
    case 'Ketu': return '☋';
    default: return '★';
  }
}

String _ordinal(int n) {
  if (n >= 11 && n <= 13) return '${n}th';
  switch (n % 10) {
    case 1: return '${n}st';
    case 2: return '${n}nd';
    case 3: return '${n}rd';
    default: return '${n}th';
  }
}

class AspectsWidget extends StatelessWidget {
  final String chartId;
  final dynamic initial;
  const AspectsWidget({super.key, required this.chartId, this.initial});

  @override
  Widget build(BuildContext context) {
    return SectionLoader(
      initial: initial is Map ? (initial as Map).cast<String, dynamic>() : null,
      loader: () => ApiService().getKundliAspects(chartId),
      builder: (ctx, data) => _AspectsView(data: data),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
class _AspectsView extends StatefulWidget {
  final Map<String, dynamic> data;
  const _AspectsView({required this.data});
  @override
  State<_AspectsView> createState() => _AspectsViewState();
}

class _AspectsViewState extends State<_AspectsView> with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Map<String, dynamic> get _graha =>
      (widget.data['graha_drishti'] as Map? ?? {}).cast<String, dynamic>();
  Map<String, dynamic> get _received =>
      (widget.data['graha_drishti_received'] as Map? ?? {}).cast<String, dynamic>();
  Map<String, dynamic> get _lagnaRecv =>
      (widget.data['lagna_aspects_received'] as Map? ?? {}).cast<String, dynamic>();
  Map<String, dynamic> get _rashi =>
      (widget.data['rashi_drishti'] as Map? ?? {}).cast<String, dynamic>();
  Map<String, dynamic> get _special =>
      (widget.data['special_aspects'] as Map? ?? {}).cast<String, dynamic>();
  Map<String, dynamic> get _signs =>
      (widget.data['planet_signs'] as Map? ?? {}).cast<String, dynamic>();

  List<String> get _planets {
    final p = (widget.data['planets'] as List?)?.cast<String>();
    return p ?? _kPlanetOrder;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(children: [
      // Tab bar + info button
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 6, 0),
        child: Row(children: [
          Expanded(
            child: TabBar(
              controller: _tabs,
              indicatorColor: AppColors.gold,
              indicatorWeight: 2.5,
              labelColor: AppColors.gold,
              unselectedLabelColor: AppColors.smoke,
              labelStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
              tabs: [
                Tab(child: _tabLabel(l.grahaDrishti, l.aspPlanetToPlanet)),
                Tab(child: _tabLabel(l.rashiDrishti, l.aspSignToSign)),
              ],
            ),
          ),
          Material(
            color: AppColors.nebula,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: AppColors.gold.withOpacity(0.3))),
            child: IconButton(
              icon: const Icon(Icons.info_outline, color: AppColors.gold, size: 20),
              tooltip: l.aspInfoTitle,
              onPressed: () => _openInfo(l),
            ),
          ),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        child: _legend(l),
      ),
      Expanded(
        child: TabBarView(controller: _tabs, children: [
          _grahaTab(l),
          _rashiTab(l),
        ]),
      ),
    ]);
  }

  Widget _tabLabel(String title, String sub) => Column(mainAxisSize: MainAxisSize.min, children: [
        Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        Text(sub, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
      ]);

  // ── Section 8: legend ────────────────────────────────────────────────
  Widget _legend(AppLocalizations l) {
    Widget dot(Color c, String label, {bool star = false, bool ring = false}) =>
        Row(mainAxisSize: MainAxisSize.min, children: [
          if (star) Text('⭐', style: const TextStyle(fontSize: 11))
          else Container(
            width: 11, height: 11,
            decoration: BoxDecoration(
              color: ring ? Colors.transparent : c,
              shape: BoxShape.circle,
              border: ring ? Border.all(color: AppColors.smoke, width: 1.4) : null,
            ),
          ),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w600)),
        ]);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Wrap(spacing: 12, runSpacing: 7, alignment: WrapAlignment.center, children: [
        dot(AspectColors.present, l.aspPresent),
        dot(Colors.transparent, l.aspNotPresent, ring: true),
        dot(AspectColors.graha, l.aspGrahaAspect),
        dot(AspectColors.rashi, l.aspRashiAspect),
        dot(AspectColors.special, l.aspSpecialAspect, star: true),
      ]),
    );
  }

  // ═════════════════════════ GRAHA TAB ═════════════════════════════════
  Widget _grahaTab(AppLocalizations l) {
    return ListView(padding: const EdgeInsets.fromLTRB(16, 14, 16, 28), children: [
      _lagnaCard(l),
      ..._planets.asMap().entries.map((e) => _FadeIn(
            delayMs: e.key * 45,
            child: _PlanetAspectCard(
              planet: e.value,
              gives: (_graha[e.value] as Map? ?? {}).cast<String, dynamic>(),
              receives: (_received[e.value] as Map? ?? {}).cast<String, dynamic>(),
              specialHouses: ((_special[e.value] as List?) ?? const [7]).map((h) => (h as num).toInt()).toList(),
              allPlanets: _planets,
              onAspectTap: _openAspectSheet,
            ),
          )),
    ]);
  }

  // ── Section 7: Lagna aspects received ────────────────────────────────
  Widget _lagnaCard(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final from = _lagnaRecv.keys.toList();
    final none = _planets.where((p) => !_lagnaRecv.containsKey(p)).toList();
    return _FadeIn(
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.indigo.withOpacity(0.5)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.wb_twilight, color: AppColors.lavender, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(l.aspLagnaReceives,
                style: const TextStyle(color: AppColors.lavender, fontSize: 14, fontWeight: FontWeight.w800))),
          ]),
          const SizedBox(height: 12),
          if (from.isEmpty)
            Text(l.aspNoAspect, style: const TextStyle(color: AppColors.smoke, fontSize: 12))
          else
            Wrap(spacing: 8, runSpacing: 8, children: from.map((p) {
              final info = (_lagnaRecv[p] as Map).cast<String, dynamic>();
              return _aspectChip(
                label: KundliNames.planet(p, loc),
                house: (info['house'] as num?)?.toInt() ?? 7,
                onTap: () => _openLagnaSheet(p, info),
              );
            }).toList()),
          if (none.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(l.aspNoAspectFrom, style: const TextStyle(color: AppColors.smoke, fontSize: 11, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(none.map((p) => KundliNames.planet(p, loc)).join(' · '),
                style: const TextStyle(color: AppColors.ash, fontSize: 12)),
          ],
        ]),
      ),
    );
  }

  Widget _aspectChip({required String label, required int house, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        decoration: BoxDecoration(
          color: AspectColors.present.withOpacity(0.14),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AspectColors.present.withOpacity(0.5)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.check, size: 13, color: AspectColors.present),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w600)),
          const SizedBox(width: 5),
          Text(_ordinal(house),
              style: TextStyle(color: house == 7 ? AspectColors.present : AspectColors.special, fontSize: 10.5, fontWeight: FontWeight.w800)),
        ]),
      ),
    );
  }

  // ═════════════════════════ RASHI TAB ═════════════════════════════════
  Widget _rashiTab(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    return ListView(padding: const EdgeInsets.fromLTRB(16, 14, 16, 28), children: [
      Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AspectColors.rashi.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AspectColors.rashi.withOpacity(0.3)),
        ),
        child: Row(children: [
          const Icon(Icons.circle, color: AspectColors.rashi, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(l.aspRashiBody,
              style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))),
        ]),
      ),
      ..._kSignsShort.asMap().entries.map((entry) {
        final code = entry.value;
        final aspected = (_rashi[code] as List?) ?? const [];
        if (aspected.isEmpty) return const SizedBox.shrink();
        return _FadeIn(
          delayMs: entry.key * 30,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Container(
                width: 52, alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(color: AspectColors.rashi.withOpacity(0.16), borderRadius: BorderRadius.circular(10)),
                child: Text(KundliNames.rashiShort(code, loc),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AspectColors.rashi, fontSize: 12, fontWeight: FontWeight.w800)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.arrow_right_alt, color: AppColors.smoke, size: 20),
              ),
              Expanded(
                child: Wrap(spacing: 6, runSpacing: 6, children: aspected.map<Widget>((r) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: AspectColors.rashi.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AspectColors.rashi.withOpacity(0.3)),
                  ),
                  child: Text(KundliNames.rashiShort(r.toString(), loc),
                      style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, fontWeight: FontWeight.w600)),
                )).toList()),
              ),
            ]),
          ),
        );
      }),
    ]);
  }

  // ── Section 5: aspect detail bottom sheet ────────────────────────────
  void _openAspectSheet(String from, String to, Map<String, dynamic> info) {
    _showAspectSheet(from: from, to: to, info: info, toIsLagna: false);
  }

  void _openLagnaSheet(String from, Map<String, dynamic> info) {
    _showAspectSheet(from: from, to: 'Lagna', info: info, toIsLagna: true);
  }

  void _showAspectSheet({
    required String from,
    required String to,
    required Map<String, dynamic> info,
    required bool toIsLagna,
  }) {
    final l = AppLocalizations.of(context)!;
    final loc = Localizations.localeOf(context);
    final house = (info['house'] as num?)?.toInt() ?? 7;
    final lagnaSign = (_signs['Lagna'] as num?)?.toInt() ?? 0;
    final fromSign = (_signs[from] as num?)?.toInt();
    final toSign = toIsLagna ? lagnaSign : (_signs[to] as num?)?.toInt();

    // Combined? Is there ALSO a Rashi Drishti from the aspector's sign to the target's sign?
    bool rashiToo = false;
    if (fromSign != null && toSign != null) {
      final aspected = (_rashi[_kSignsShort[fromSign]] as List?) ?? const [];
      rashiToo = aspected.contains(_kSignsShort[toSign]);
    }
    final targetHouse = (toSign != null) ? ((toSign - lagnaSign) % 12 + 1) : null;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.nebula,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: AppColors.ash, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          // title: From → To
          Row(children: [
            _sheetGlyph(from),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.arrow_right_alt, color: AppColors.gold)),
            if (toIsLagna)
              Text(l.lagna, style: const TextStyle(color: AppColors.ivory, fontSize: 17, fontWeight: FontWeight.w800))
            else
              _sheetGlyph(to),
          ]),
          const SizedBox(height: 16),
          // Aspect present
          _kv(Icons.check_circle, AspectColors.present, l.aspAspectPresent, '✅'),
          const SizedBox(height: 14),
          // Reason
          Text(l.aspReason, style: const TextStyle(color: AppColors.gold, fontSize: 12.5, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          _reasonRow(AspectColors.graha, l.aspGrahaAspect, true),
          const SizedBox(height: 6),
          _reasonRow(AspectColors.rashi, l.aspRashiAspect, rashiToo),
          if (rashiToo) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AspectColors.special.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AspectColors.special.withOpacity(0.4)),
              ),
              child: Row(children: [
                const Text('⭐ ', style: TextStyle(fontSize: 13)),
                Text(l.aspCombinedAspect, style: const TextStyle(color: AspectColors.special, fontSize: 12.5, fontWeight: FontWeight.w800)),
                const Spacer(),
                _miniBadge('🟣', l.aspGrahaAspect),
                const SizedBox(width: 6),
                _miniBadge('🟢', l.aspRashiAspect),
              ]),
            ),
          ],
          const SizedBox(height: 16),
          // Special aspect + target details
          _detailRow(l.aspSpecialAspect, '${_ordinal(house)} ${l.aspAspectWord}${house == 7 ? ' (7 · ${l.aspGrahaAspect})' : ''}',
              house == 7 ? AspectColors.present : AspectColors.special),
          if (targetHouse != null)
            _detailRow(l.aspTargetHouse, '${_ordinal(targetHouse)} ${l.house}', AppColors.parchment),
          if (toSign != null)
            _detailRow(l.aspTargetSign, KundliNames.rashiShort(_kSignsShort[toSign], loc), AppColors.parchment),
        ]),
      ),
    );
  }

  Widget _sheetGlyph(String p) {
    final loc = Localizations.localeOf(context);
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text(_glyph(p), style: const TextStyle(fontSize: 20, color: AppColors.gold)),
      const SizedBox(width: 6),
      Text(KundliNames.planet(p, loc), style: const TextStyle(color: AppColors.ivory, fontSize: 17, fontWeight: FontWeight.w800)),
    ]);
  }

  Widget _kv(IconData ic, Color c, String label, String trailing) => Row(children: [
        Icon(ic, color: c, size: 18),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w700)),
        const Spacer(),
        Text(trailing, style: const TextStyle(fontSize: 15)),
      ]);

  Widget _reasonRow(Color c, String label, bool present) => Row(children: [
        Container(width: 11, height: 11, decoration: BoxDecoration(color: present ? c : Colors.transparent, shape: BoxShape.circle, border: present ? null : Border.all(color: AppColors.smoke, width: 1.3))),
        const SizedBox(width: 9),
        Text(label, style: TextStyle(color: present ? AppColors.parchment : AppColors.smoke, fontSize: 13, fontWeight: FontWeight.w600)),
        const Spacer(),
        Text(present ? '✅' : '⚪', style: const TextStyle(fontSize: 13)),
      ]);

  Widget _miniBadge(String emoji, String label) => Row(mainAxisSize: MainAxisSize.min, children: [
        Text(emoji, style: const TextStyle(fontSize: 11)),
        const SizedBox(width: 3),
        Text(label, style: const TextStyle(color: AppColors.parchment, fontSize: 10.5, fontWeight: FontWeight.w600)),
      ]);

  Widget _detailRow(String k, String v, Color vColor) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(children: [
          Text(k, style: const TextStyle(color: AppColors.smoke, fontSize: 12.5)),
          const Spacer(),
          Flexible(child: Text(v, textAlign: TextAlign.right, style: TextStyle(color: vColor, fontSize: 13, fontWeight: FontWeight.w700))),
        ]),
      );

  // ── Section 9: info sheet ────────────────────────────────────────────
  void _openInfo(AppLocalizations l) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (bctx, scroll) => Container(
          decoration: const BoxDecoration(
            color: AppColors.nebula,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: ListView(controller: scroll, padding: const EdgeInsets.fromLTRB(18, 10, 18, 28), children: [
            Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: AppColors.ash, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            Row(children: [
              const Icon(Icons.auto_stories, color: AppColors.gold, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(l.aspInfoTitle,
                  style: const TextStyle(color: AppColors.gold, fontSize: 17, fontWeight: FontWeight.w800))),
            ]),
            const SizedBox(height: 16),
            _InfoTile(q: l.aspQGraha, a: l.aspGrahaBody),
            _InfoTile(q: l.aspQRashi, a: l.aspRashiBody),
            _InfoTile(q: l.aspQDiff, a: l.aspDiffBody),
            _InfoTile(q: l.aspQPredict, a: l.aspPredictBody),
          ]),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  Expandable planet aspect card (Sections 2, 3, 4)
// ═══════════════════════════════════════════════════════════════════════
class _PlanetAspectCard extends StatefulWidget {
  final String planet;
  final Map<String, dynamic> gives;
  final Map<String, dynamic> receives;
  final List<int> specialHouses;
  final List<String> allPlanets;
  final void Function(String from, String to, Map<String, dynamic> info) onAspectTap;

  const _PlanetAspectCard({
    required this.planet,
    required this.gives,
    required this.receives,
    required this.specialHouses,
    required this.allPlanets,
    required this.onAspectTap,
  });

  @override
  State<_PlanetAspectCard> createState() => _PlanetAspectCardState();
}

class _PlanetAspectCardState extends State<_PlanetAspectCard> {
  bool _open = false;

  String _trait(AppLocalizations l, String p) {
    switch (p) {
      case 'Sun': return l.aspTraitSun;
      case 'Moon': return l.aspTraitMoon;
      case 'Mars': return l.aspTraitMars;
      case 'Mercury': return l.aspTraitMercury;
      case 'Jupiter': return l.aspTraitJupiter;
      case 'Venus': return l.aspTraitVenus;
      case 'Saturn': return l.aspTraitSaturn;
      case 'Rahu': return l.aspTraitRahu;
      case 'Ketu': return l.aspTraitKetu;
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final loc = Localizations.localeOf(context);
    final name = KundliNames.planet(widget.planet, loc);
    final giveKeys = widget.gives.keys.toList();
    final recvKeys = widget.receives.keys.toList();
    final noInfluence = widget.allPlanets.where((p) => p != widget.planet && !widget.gives.containsKey(p)).toList();
    // special houses beyond the universal 7th
    final specials = widget.specialHouses.where((h) => h != 7).toList()..sort();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AspectColors.graha.withOpacity(0.25)),
      ),
      child: Column(children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Container(
                width: 40, height: 40, alignment: Alignment.center,
                decoration: BoxDecoration(color: AspectColors.graha.withOpacity(0.16), shape: BoxShape.circle),
                child: Text(_glyph(widget.planet), style: const TextStyle(fontSize: 18, color: AspectColors.graha)),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name, style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text('${l.aspTotalGiven}: ${giveKeys.length}   ·   ${l.aspTotalReceived}: ${recvKeys.length}',
                    style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
              ])),
              if (specials.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Text('⭐', style: const TextStyle(fontSize: 13)),
                ),
              AnimatedRotation(
                turns: _open ? 0.5 : 0,
                duration: const Duration(milliseconds: 240),
                child: const Icon(Icons.expand_more, color: AspectColors.graha),
              ),
            ]),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Divider(height: 1),
              const SizedBox(height: 12),
              // Gives aspect to
              _heading(l.aspGivesAspectTo, AspectColors.graha),
              const SizedBox(height: 7),
              if (giveKeys.isEmpty)
                Text(l.aspNoInfluence, style: const TextStyle(color: AppColors.smoke, fontSize: 12))
              else
                Wrap(spacing: 8, runSpacing: 8, children: giveKeys.map((t) {
                  final info = (widget.gives[t] as Map).cast<String, dynamic>();
                  return _chip(KundliNames.planet(t, loc), (info['house'] as num?)?.toInt() ?? 7,
                      () => widget.onAspectTap(widget.planet, t, info));
                }).toList()),
              const SizedBox(height: 14),
              // Receives aspect from
              _heading(l.aspReceivesAspectFrom, AppColors.lavender),
              const SizedBox(height: 7),
              if (recvKeys.isEmpty)
                Text(l.aspNoAspect, style: const TextStyle(color: AppColors.smoke, fontSize: 12))
              else
                Wrap(spacing: 8, runSpacing: 8, children: recvKeys.map((f) {
                  final info = (widget.receives[f] as Map).cast<String, dynamic>();
                  return _chip(KundliNames.planet(f, loc), (info['house'] as num?)?.toInt() ?? 7,
                      () => widget.onAspectTap(f, widget.planet, info));
                }).toList()),
              // Special aspects
              if (specials.isNotEmpty) ...[
                const SizedBox(height: 14),
                _heading(l.aspSpecialAspect, AspectColors.special),
                const SizedBox(height: 7),
                Wrap(spacing: 8, runSpacing: 8, children: [7, ...specials].map((h) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AspectColors.special.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AspectColors.special.withOpacity(0.4)),
                  ),
                  child: Text('⭐ ${_ordinal(h)}', style: const TextStyle(color: AspectColors.special, fontSize: 11.5, fontWeight: FontWeight.w800)),
                )).toList()),
              ],
              // AI explanation
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.twilight.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.lavender.withOpacity(0.25)),
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Padding(padding: EdgeInsets.only(top: 1, right: 8), child: Text('🔮', style: TextStyle(fontSize: 14))),
                  Expanded(child: Text(
                    giveKeys.isEmpty
                        ? l.aspAiNone(name)
                        : l.aspAiInfluence(name, giveKeys.map((t) => KundliNames.planet(t, loc)).join(', '), _trait(l, widget.planet)),
                    style: const TextStyle(color: AppColors.parchment, fontSize: 12.3, height: 1.45),
                  )),
                ]),
              ),
              if (noInfluence.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text('${l.aspNoInfluence}: ${noInfluence.map((p) => KundliNames.planet(p, loc)).join(' · ')}',
                    style: const TextStyle(color: AppColors.ash, fontSize: 11.5)),
              ],
            ]),
          ),
          crossFadeState: _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 260),
          sizeCurve: Curves.easeInOut,
        ),
      ]),
    );
  }

  Widget _heading(String t, Color c) => Text(t,
      style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.2));

  Widget _chip(String label, int house, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        decoration: BoxDecoration(
          color: AspectColors.present.withOpacity(0.14),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AspectColors.present.withOpacity(0.5)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.check, size: 13, color: AspectColors.present),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w600)),
          const SizedBox(width: 5),
          Text(_ordinal(house),
              style: TextStyle(color: house == 7 ? AspectColors.present : AspectColors.special, fontSize: 10.5, fontWeight: FontWeight.w800)),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  Info Q&A tile
// ═══════════════════════════════════════════════════════════════════════
class _InfoTile extends StatefulWidget {
  final String q;
  final String a;
  const _InfoTile({required this.q, required this.a});
  @override
  State<_InfoTile> createState() => _InfoTileState();
}

class _InfoTileState extends State<_InfoTile> {
  bool _open = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.twilight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Row(children: [
              Expanded(child: Text(widget.q,
                  style: const TextStyle(color: AppColors.ivory, fontSize: 13.5, fontWeight: FontWeight.w700))),
              AnimatedRotation(
                turns: _open ? 0.5 : 0,
                duration: const Duration(milliseconds: 220),
                child: const Icon(Icons.expand_more, color: AppColors.gold, size: 20),
              ),
            ]),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: Padding(
            padding: const EdgeInsets.fromLTRB(13, 0, 13, 13),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(widget.a, style: const TextStyle(color: AppColors.parchment, fontSize: 12.5, height: 1.5)),
            ),
          ),
          crossFadeState: _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 240),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  Staggered fade-in
// ═══════════════════════════════════════════════════════════════════════
class _FadeIn extends StatefulWidget {
  final Widget child;
  final int delayMs;
  const _FadeIn({required this.child, this.delayMs = 0});
  @override
  State<_FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<_FadeIn> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 420));

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, child) {
        final t = Curves.easeOutCubic.transform(_c.value);
        return Opacity(opacity: _c.value, child: Transform.translate(offset: Offset(0, (1 - t) * 14), child: child));
      },
      child: widget.child,
    );
  }
}
