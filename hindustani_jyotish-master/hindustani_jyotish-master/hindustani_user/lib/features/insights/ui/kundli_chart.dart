import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

import '../insight_models.dart';

/// North-Indian style diamond kundli chart, drawn with a [CustomPainter]
/// (no package dependency). House 1 is the top-centre diamond and always
/// holds the lagna sign; houses run counter-clockwise. Each house shows its
/// rashi number (1 = Aries … 12 = Pisces) plus the abbreviations of the
/// planets placed there; retrograde (vakri) planets carry an "(R)" marker.
class KundliChart extends StatelessWidget {
  const KundliChart({
    super.key,
    required this.lagnaSignIdx,
    required this.planets,
  });

  /// 0 = Aries … 11 = Pisces.
  final int lagnaSignIdx;
  final List<InsightPlanet> planets;

  @override
  Widget build(BuildContext context) {
    // Planet labels in the app's selected language (falls back to the English
    // two-letter code for English/unknown locales), so the chart reads in the
    // local language like the rest of the kundli.
    final lang = Localizations.localeOf(context).languageCode;
    // Bucket planets into houses relative to the lagna sign.
    final houses = List.generate(12, (_) => <String>[]);
    for (final p in planets) {
      final idx = p.signIdx;
      if (idx == null) continue;
      final house = ((idx - lagnaSignIdx) % 12 + 12) % 12; // 0-based
      houses[house].add('${planetChartAbbr(p.name, lang)}${p.vakri ? '(R)' : ''}');
    }
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: _KundliChartPainter(
          lagnaSignIdx: lagnaSignIdx,
          houses: houses,
          lineColor: AppColors.gold,
          signColor: AppColors.ivoryFaint,
          planetColor: AppColors.saffronBright,
          fillColor: AppColors.surface1,
        ),
      ),
    );
  }
}

class _KundliChartPainter extends CustomPainter {
  _KundliChartPainter({
    required this.lagnaSignIdx,
    required this.houses,
    required this.lineColor,
    required this.signColor,
    required this.planetColor,
    required this.fillColor,
  });

  final int lagnaSignIdx;
  final List<List<String>> houses;
  final Color lineColor;
  final Color signColor;
  final Color planetColor;
  final Color fillColor;

  // Anchor points (fractions of the side) per house, counter-clockwise from
  // the top-centre diamond. `sign` sits toward the house's outer tip, `body`
  // holds the planet abbreviations.
  static const _signAnchors = [
    Offset(0.50, 0.115), // 1  top diamond
    Offset(0.25, 0.055), // 2  top-left upper triangle
    Offset(0.055, 0.25), // 3  left-top triangle
    Offset(0.115, 0.50), // 4  left diamond
    Offset(0.055, 0.75), // 5  left-bottom triangle
    Offset(0.25, 0.945), // 6  bottom-left triangle
    Offset(0.50, 0.885), // 7  bottom diamond
    Offset(0.75, 0.945), // 8  bottom-right triangle
    Offset(0.945, 0.75), // 9  right-bottom triangle
    Offset(0.885, 0.50), // 10 right diamond
    Offset(0.945, 0.25), // 11 right-top triangle
    Offset(0.75, 0.055), // 12 top-right triangle
  ];
  static const _bodyAnchors = [
    Offset(0.50, 0.28),
    Offset(0.25, 0.145),
    Offset(0.145, 0.25),
    Offset(0.27, 0.50),
    Offset(0.145, 0.75),
    Offset(0.25, 0.845),
    Offset(0.50, 0.70),
    Offset(0.75, 0.845),
    Offset(0.855, 0.75),
    Offset(0.73, 0.50),
    Offset(0.855, 0.25),
    Offset(0.75, 0.145),
  ];

  /// Max abbreviations per line before wrapping — the narrow side triangles
  /// (houses 3/5/9/11, 0-based 2/4/8/10) stack one per line.
  static int _perLine(int house) => switch (house) {
        2 || 4 || 8 || 10 => 1,
        1 || 5 || 7 || 11 => 2,
        _ => 3,
      };

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final rect = Rect.fromLTWH(0, 0, s, s);

    final fill = Paint()..color = fillColor;
    canvas.drawRect(rect, fill);

    final line = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    // Outer square.
    canvas.drawRect(rect, line);
    // Diagonals.
    canvas.drawLine(Offset.zero, Offset(s, s), line);
    canvas.drawLine(Offset(s, 0), Offset(0, s), line);
    // Midpoint diamond.
    final path = Path()
      ..moveTo(s / 2, 0)
      ..lineTo(s, s / 2)
      ..lineTo(s / 2, s)
      ..lineTo(0, s / 2)
      ..close();
    canvas.drawPath(path, line);

    for (var h = 0; h < 12; h++) {
      final signNumber = ((lagnaSignIdx + h) % 12) + 1;
      _drawText(
        canvas,
        '$signNumber',
        Offset(_signAnchors[h].dx * s, _signAnchors[h].dy * s),
        TextStyle(
          color: signColor,
          fontSize: s * 0.032,
          fontWeight: FontWeight.w600,
        ),
        maxWidth: s * 0.2,
      );

      final entries = houses[h];
      if (entries.isEmpty) continue;
      final perLine = _perLine(h);
      final lines = <String>[];
      for (var i = 0; i < entries.length; i += perLine) {
        lines.add(entries
            .sublist(i, i + perLine > entries.length ? entries.length : i + perLine)
            .join(' '));
      }
      _drawText(
        canvas,
        lines.join('\n'),
        Offset(_bodyAnchors[h].dx * s, _bodyAnchors[h].dy * s),
        TextStyle(
          color: planetColor,
          fontSize: s * 0.038,
          fontWeight: FontWeight.w700,
          height: 1.25,
        ),
        maxWidth: s * 0.26,
      );
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset center,
    TextStyle style, {
    required double maxWidth,
  }) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(_KundliChartPainter old) =>
      old.lagnaSignIdx != lagnaSignIdx ||
      old.lineColor != lineColor ||
      old.signColor != signColor ||
      old.planetColor != planetColor ||
      old.fillColor != fillColor ||
      !_sameHouses(old.houses, houses);

  static bool _sameHouses(List<List<String>> a, List<List<String>> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].length != b[i].length) return false;
      for (var j = 0; j < a[i].length; j++) {
        if (a[i][j] != b[i][j]) return false;
      }
    }
    return true;
  }
}
