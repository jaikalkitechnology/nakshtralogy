import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'specialist_chart_picker.dart';
import 'specialist_milan_picker.dart';
import 'specialist_relationship_picker.dart';
import 'multi_chart_picker.dart';

class SpecialistListScreen extends StatefulWidget {
  final bool showAppBar;
  const SpecialistListScreen({super.key, this.showAppBar = true});
  @override
  State<SpecialistListScreen> createState() => _S();
}

class _S extends State<SpecialistListScreen> {
  String _filter = 'all';

  static const _groups = <Map<String, dynamic>>[
    {'label': '⚡ CAREER & PURPOSE', 'filter': 'career', 'engines': [
      {'key': 'career', 'num': '01', 'icon': '💼', 'title': 'Career &', 'em': 'Profession', 'sub': '98 KEYS · 9 SECTIONS', 'premium': false},
      {'key': 'business', 'num': '02', 'icon': '🚀', 'title': 'Business &', 'em': 'Startup', 'sub': '~90 KEYS · 14 SECTIONS', 'premium': false},
      {'key': 'education', 'num': '03', 'icon': '📚', 'title': 'Education &', 'em': 'Learning', 'sub': '~120 KEYS · 15 SECTIONS', 'premium': false},
      {'key': 'life_path', 'num': '12', 'icon': '✦', 'title': 'Life Path &', 'em': 'Luck', 'sub': '~150 KEYS · 18 SECTIONS', 'premium': true},
    ]},
    {'label': '💰 WEALTH & ASSETS', 'filter': 'wealth', 'engines': [
      {'key': 'wealth', 'num': '04', 'icon': '💎', 'title': 'Wealth &', 'em': 'Finance', 'sub': '~85 KEYS · 16 SECTIONS', 'premium': false},
      {'key': 'debt_recovery', 'num': '05', 'icon': '⚖', 'title': 'Debt &', 'em': 'Recovery', 'sub': '~100 KEYS · 17 SECTIONS', 'premium': false},
      {'key': 'property', 'num': '10', 'icon': '🏘', 'title': 'Property &', 'em': 'Assets', 'sub': '~140 KEYS · 18 SECTIONS', 'premium': false},
      {'key': 'legal', 'num': '11', 'icon': '⚖️', 'title': 'Legal &', 'em': 'Disputes', 'sub': '~140 KEYS · 17 SECTIONS', 'premium': false},
    ]},
    {'label': '💕 LOVE & RELATIONSHIPS', 'filter': 'love', 'engines': [
      {'key': 'love', 'num': '06', 'icon': '💕', 'title': 'Love &', 'em': 'Romance', 'sub': '~120 KEYS · 18 SECTIONS', 'premium': false},
      {'key': 'marriage', 'num': '07', 'icon': '💍', 'title': 'Marriage &', 'em': 'Family', 'sub': '~150 KEYS · 19 SECTIONS', 'premium': true},
      {'key': 'kundli_milan', 'num': '15', 'icon': '⚭', 'title': 'Kundli', 'em': 'Milan', 'sub': '186 KEYS · DUAL CHART', 'premium': true},
      {'key': 'relationship', 'num': '16', 'icon': '🔗', 'title': 'Relationship', 'em': 'Intel', 'sub': '~120 PER PAIR · MULTI', 'premium': true},
      {'key': 'love_compatibility', 'num': '18', 'icon': '💞', 'title': 'Love', 'em': 'Compatibility', 'sub': 'DUAL CHART · M+F', 'premium': true, 'multi': true},
      {'key': 'child_probability', 'num': '17', 'icon': '👶', 'title': 'Child', 'em': 'Probability', 'sub': 'DUAL CHART · M+F', 'premium': true, 'multi': true},
    ]},
    {'label': '🌿 HEALTH & WELLNESS', 'filter': 'health', 'engines': [
      {'key': 'health', 'num': '08', 'icon': '❤', 'title': 'Health &', 'em': 'Wellness', 'sub': '~130 KEYS · 18 SECTIONS', 'premium': false},
      {'key': 'mental_stress', 'num': '09', 'icon': '🧠', 'title': 'Mental &', 'em': 'Stress', 'sub': '~160 KEYS · 18 SECTIONS', 'premium': false},
    ]},
    {'label': '☥ SOUL & KARMA', 'filter': 'soul', 'engines': [
      {'key': 'character', 'num': '13', 'icon': '👤', 'title': 'Character', 'em': 'Analysis', 'sub': '177 KEYS · 20 SECTIONS', 'premium': false},
      {'key': 'past_life', 'num': '14', 'icon': '☥', 'title': 'Past Life &', 'em': 'Karma', 'sub': '116 KEYS · 16 SECTIONS', 'premium': true},
      {'key': 'karma_linkage', 'num': '19', 'icon': '🔮', 'title': 'Past Life Karma', 'em': 'Linkage', 'sub': '2-5 CHARTS · MULTI', 'premium': true, 'multi': true},
    ]},
  ];

  static const _filters = ['all', 'career', 'wealth', 'love', 'health', 'soul'];
  static const _filterLabels = {'all': 'All · 19', 'career': 'Career · 4', 'wealth': 'Wealth · 4', 'love': 'Love · 6', 'health': 'Health · 2', 'soul': 'Soul · 3'};

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final groupLabels = {
      'career': '⚡ ${l.careerPurpose}',
      'wealth': '💰 ${l.wealthAssets}',
      'love': '💕 ${l.loveRelationships}',
      'health': '🌿 ${l.healthWellness}',
      'soul': '☥ ${l.soulKarma}',
    };
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A24),
      appBar: widget.showAppBar ? AppBar(backgroundColor: const Color(0xFF0A0A24),
        title: Text.rich(TextSpan(children: [
          TextSpan(text: '${l.allInsights.split(' ').first} ', style: const TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w600)),
          TextSpan(text: l.allInsights.split(' ').skip(1).join(' ').isEmpty ? 'Insights' : l.allInsights.split(' ').skip(1).join(' '), style: const TextStyle(color: AppColors.gold, fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500)),
        ]))) : null,
      body: ListView(padding: EdgeInsets.only(top: widget.showAppBar ? 0 : 12), children: [
        _banner(l),
        _filterPills(),
        ..._groups.where((g) => _filter == 'all' || g['filter'] == _filter).expand((g) => [
          _groupDivider(groupLabels[g['filter']] ?? g['label'] as String),
          _engineGrid((g['engines'] as List).cast<Map<String, dynamic>>()),
        ]),
        const SizedBox(height: 80),
      ]),
    );
  }

  Widget _banner(AppLocalizations l) => Container(
    margin: const EdgeInsets.fromLTRB(16, 8, 16, 12), padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [AppColors.gold.withOpacity(0.12), const Color(0xFF4A3B8C).withOpacity(0.15)]),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.gold.withOpacity(0.25))),
    child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 16, height: 1, color: AppColors.gold.withOpacity(0.4)), const SizedBox(width: 6),
        Text('★ ${l.yourCompleteReading}', style: const TextStyle(color: AppColors.gold, fontSize: 9, fontWeight: FontWeight.w700)),
        const SizedBox(width: 6), Container(width: 16, height: 1, color: AppColors.gold.withOpacity(0.4)),
      ]),
      const SizedBox(height: 10),
      Text.rich(TextSpan(children: [
        const TextSpan(text: '19 ', style: TextStyle(color: AppColors.ivory, fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'serif')),
        TextSpan(text: l.expertEngines, style: const TextStyle(color: AppColors.gold, fontSize: 20, fontStyle: FontStyle.italic, fontFamily: 'serif')),
      ])),
      const SizedBox(height: 4),
      Text(l.eachInsightConsultation, style: const TextStyle(color: AppColors.smoke, fontSize: 10)),
      const SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _bannerStat('19', l.engines), _bannerStat('2,000+', l.dataPoints), _bannerStat('14', l.singleChart),
      ]),
    ]));

  Widget _bannerStat(String num, String label) => Column(children: [
    Text(num, style: const TextStyle(color: AppColors.gold, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'serif')),
    Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 8, fontWeight: FontWeight.w600)),
  ]);

  Widget _filterPills() => SizedBox(height: 32, child: ListView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    children: _filters.map((f) {
      final active = _filter == f;
      return GestureDetector(
        onTap: () => setState(() => _filter = f),
        child: Container(
          margin: const EdgeInsets.only(right: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: active ? const LinearGradient(colors: [AppColors.gold, AppColors.saffron]) : null,
            color: active ? null : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: active ? Colors.transparent : AppColors.gold.withOpacity(0.2))),
          child: Text(_filterLabels[f]!, style: TextStyle(
            color: active ? AppColors.midnight : AppColors.smoke,
            fontSize: 10, fontWeight: active ? FontWeight.w700 : FontWeight.w500))));
    }).toList()));

  Widget _groupDivider(String label) => Container(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700)));

  Widget _engineGrid(List<Map<String, dynamic>> engines) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Wrap(spacing: 8, runSpacing: 8, children: engines.map((e) => _engineTile(e)).toList()));

  Widget _engineTile(Map<String, dynamic> e) {
    final premium = e['premium'] == true;
    return GestureDetector(
      onTap: () => _openEngine(e['key'] as String, '${e['title']} ${e['em']}', e['icon'] as String),
      child: SizedBox(
        width: (MediaQuery.of(context).size.width - 40) / 2,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [AppColors.gold.withOpacity(0.08), const Color(0xFF1A1642).withOpacity(0.6)]),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gold.withOpacity(0.2))),
          child: Stack(children: [
            if (premium) Positioned(top: -2, right: -2,
              child: Container(padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                child: const Text('★', style: TextStyle(color: AppColors.gold, fontSize: 8)))),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(e['num'] as String, style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
                const Spacer(),
                Text(e['icon'] as String, style: const TextStyle(fontSize: 20)),
              ]),
              const SizedBox(height: 8),
              Text.rich(TextSpan(children: [
                TextSpan(text: '${e['title']} ', style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w600)),
                TextSpan(text: e['em'] as String, style: const TextStyle(color: AppColors.gold, fontSize: 13, fontStyle: FontStyle.italic)),
              ])),
              const SizedBox(height: 3),
              Text(e['sub'] as String, style: const TextStyle(color: AppColors.smoke, fontSize: 8, fontFamily: 'monospace', letterSpacing: 0.5)),
            ]),
          ]),
        )));
  }

  void _openEngine(String key, String label, String emoji) {
    if (key == 'kundli_milan') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const SpecialistMilanPicker()));
    } else if (key == 'relationship') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const SpecialistRelationshipPicker()));
    } else if (key == 'child_probability' || key == 'love_compatibility') {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => MultiChartPicker(specialistKey: key, specialistLabel: label, specialistEmoji: emoji, maxCharts: 2)));
    } else if (key == 'karma_linkage') {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => MultiChartPicker(specialistKey: key, specialistLabel: label, specialistEmoji: emoji, maxCharts: 5)));
    } else {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => SpecialistChartPicker(specialistKey: key, specialistLabel: label, specialistEmoji: emoji)));
    }
  }
}
