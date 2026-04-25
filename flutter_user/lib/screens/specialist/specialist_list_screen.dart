import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'specialist_chart_picker.dart';
import 'specialist_milan_picker.dart';

class SpecialistListScreen extends StatefulWidget {
  const SpecialistListScreen({super.key});

  @override
  State<SpecialistListScreen> createState() => _SpecialistListScreenState();
}

class _SpecialistListScreenState extends State<SpecialistListScreen> {
  static const _specialists = <Map<String, String>>[
    {'key': 'career',        'label': 'Career & Job',         'emoji': '💼', 'desc': 'Career path, promotion, job stability'},
    {'key': 'business',      'label': 'Business & Startup',   'emoji': '🚀', 'desc': 'Business potential, partnership, growth'},
    {'key': 'education',     'label': 'Education & Learning', 'emoji': '🎓', 'desc': 'Academic success, exams, higher studies'},
    {'key': 'wealth',        'label': 'Wealth & Finance',     'emoji': '💰', 'desc': 'Income, investments, financial growth'},
    {'key': 'debt_recovery', 'label': 'Debt & Recovery',      'emoji': '📉', 'desc': 'Debt load, recovery timing, financial healing'},
    {'key': 'love',          'label': 'Love & Relationships', 'emoji': '❤️', 'desc': 'Love capacity, romantic style, timing'},
    {'key': 'marriage',      'label': 'Marriage & Family',    'emoji': '💒', 'desc': 'Marriage timing, spouse nature, family harmony'},
    {'key': 'health',        'label': 'Health & Wellness',    'emoji': '🏥', 'desc': 'Vitality, immunity, constitutional type'},
    {'key': 'mental_stress', 'label': 'Mental & Stress',      'emoji': '🧠', 'desc': 'Mental stability, anxiety, resilience'},
    {'key': 'property',      'label': 'Property & Assets',    'emoji': '🏠', 'desc': 'Property acquisition, real estate, assets'},
    {'key': 'legal',         'label': 'Legal & Disputes',     'emoji': '⚖️', 'desc': 'Legal issues, court cases, dispute resolution'},
    {'key': 'life_path',     'label': 'Life Path & Luck',     'emoji': '🌟', 'desc': 'Dharma, fortune, karmic momentum'},
    {'key': 'character',     'label': 'Character Analysis',   'emoji': '🔍', 'desc': '51 personality traits, trust, loyalty, ethics'},
    {'key': 'past_life',     'label': 'Past Life & Karma',    'emoji': '🔮', 'desc': 'Past life themes, karmic carry-forward'},
    {'key': 'kundli_milan', 'label': 'Kundli Milan',          'emoji': '💑', 'desc': 'Match 2 charts — compatibility, doshas, timing'},
  ];

  static const _colors = <String, Color>{
    'career': Colors.blue, 'business': Colors.indigo, 'education': Colors.cyan,
    'wealth': Colors.green, 'debt_recovery': Colors.orange, 'love': Colors.pink,
    'marriage': Colors.deepOrange, 'health': Colors.red, 'mental_stress': Colors.purple,
    'property': Colors.brown, 'legal': Colors.blueGrey, 'life_path': Colors.amber,
    'character': Colors.teal, 'past_life': Colors.deepPurple,
    'kundli_milan': Colors.pink,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dept Reports', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _specialists.length,
        itemBuilder: (ctx, i) {
          final s = _specialists[i];
          final color = _colors[s['key']] ?? Colors.blue;
          return GestureDetector(
            onTap: () {
              if (s['key'] == 'kundli_milan') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SpecialistMilanPicker()));
              } else {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => SpecialistChartPicker(
                    specialistKey: s['key']!, specialistLabel: s['label']!, specialistEmoji: s['emoji']!)));
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [color.withOpacity(0.12), color.withOpacity(0.03)]),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withOpacity(0.25)),
              ),
              child: Row(children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Text(s['emoji']!, style: const TextStyle(fontSize: 22))),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s['label']!, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(s['desc']!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                ])),
                Icon(Icons.chevron_right, color: color.withOpacity(0.6), size: 22),
              ]),
            ),
          );
        },
      ),
    );
  }
}
