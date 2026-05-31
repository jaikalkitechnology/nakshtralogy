import 'package:flutter/material.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/app_theme.dart';

/// North Indian diamond-style kundli chart drawn with CustomPainter.
///
/// Geometry: outer square + inscribed diamond (midpoints) + diagonals
/// creates 12 triangular houses. House 1 (Ascendant) is always at top-center
/// of the diamond. Houses go clockwise: 2 upper-right, 3 right-corner, etc.
///
/// [houses] — list of 12 house maps, each with:
///   house, rashi_idx, rashi_short, rashi, planets, is_lagna
/// [chartTitle] — shown at center (e.g. "Lagna", "Moon", "Sun")
class NorthIndianChartWidget extends StatelessWidget {
  final List<dynamic> houses;
  final String chartTitle;
  final double? size;

  const NorthIndianChartWidget({
    super.key,
    required this.houses,
    this.chartTitle = 'Lagna',
    this.size,
  });

  Map<String, dynamic>? _house(int h) {
    for (final house in houses) {
      if (house is Map && (house['house'] as num?)?.toInt() == h) {
        return Map<String, dynamic>.from(house);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final side = size ?? MediaQuery.of(context).size.width - 32;
    return Column(children: [
      Container(
        width: side,
        height: side,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(4),
        ),
        child: CustomPaint(
          size: Size(side, side),
          painter: _ChartPainter(),
          child: _buildOverlay(side),
        ),
      ),
      const SizedBox(height: 8),
      _legend(),
    ]);
  }

  Widget _buildOverlay(double w) {
    final positions = _housePositions(w);
    return Stack(children: [
      // Center label
      Positioned(
        left: w * 0.35,
        top: w * 0.42,
        width: w * 0.30,
        height: w * 0.16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(chartTitle,
                style: const TextStyle(color: Color(0xFFE0A526), fontSize: 11, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
      // House cells
      for (int h = 1; h <= 12; h++)
        Positioned(
          left: positions[h]!['x']! - positions[h]!['w']! / 2,
          top: positions[h]!['y']! - positions[h]!['h']! / 2,
          width: positions[h]!['w']!,
          height: positions[h]!['h']!,
          child: _houseCell(h, w),
        ),
    ]);
  }

  /// House positions — North Indian traditional (counterclockwise from H1 at top).
  /// H1=top, H2=upper-left, H3=left-corner, H4=left, H5=lower-left,
  /// H6=bottom-left, H7=bottom, H8=bottom-right, H9=right-corner,
  /// H10=right, H11=upper-right, H12=top-right.
  Map<int, Map<String, double>> _housePositions(double w) {
    final cw = w * 0.22;
    final ch = w * 0.16;
    final dw = w * 0.24;
    final dh = w * 0.20;
    return {
      1:  {'x': w * 0.50, 'y': w * 0.18, 'w': dw, 'h': dh},
      2:  {'x': w * 0.26, 'y': w * 0.08, 'w': cw, 'h': ch},
      3:  {'x': w * 0.10, 'y': w * 0.24, 'w': cw, 'h': ch},
      4:  {'x': w * 0.22, 'y': w * 0.50, 'w': dw, 'h': dh},
      5:  {'x': w * 0.10, 'y': w * 0.76, 'w': cw, 'h': ch},
      6:  {'x': w * 0.26, 'y': w * 0.92, 'w': cw, 'h': ch},
      7:  {'x': w * 0.50, 'y': w * 0.82, 'w': dw, 'h': dh},
      8:  {'x': w * 0.74, 'y': w * 0.92, 'w': cw, 'h': ch},
      9:  {'x': w * 0.90, 'y': w * 0.76, 'w': cw, 'h': ch},
      10: {'x': w * 0.78, 'y': w * 0.50, 'w': dw, 'h': dh},
      11: {'x': w * 0.90, 'y': w * 0.24, 'w': cw, 'h': ch},
      12: {'x': w * 0.74, 'y': w * 0.08, 'w': cw, 'h': ch},
    };
  }

  Widget _houseCell(int houseNum, double w) {
    final house = _house(houseNum);
    if (house == null) return const SizedBox.shrink();
    final rashiIdx = (house['rashi_idx'] as num?)?.toInt() ?? 0;
    final planets = (house['planets'] as List?) ?? [];
    final isLagna = house['is_lagna'] == true;
    final fontSize = w < 340 ? 9.0 : 10.0;

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Rashi number
        Text(
          '${rashiIdx + 1}',
          style: TextStyle(
            color: isLagna ? const Color(0xFFE0A526) : const Color(0xFFE0A526).withOpacity(0.7),
            fontSize: isLagna ? fontSize + 2 : fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        // Planets
        if (planets.isNotEmpty)
          ...planets.take(3).map<Widget>((p) {
            final planet = p as Map;
            final name = (planet['planet'] ?? '').toString();
            final degree = (planet['degree'] as num?)?.toInt() ?? 0;
            final flags = (planet['flags'] as List?) ?? [];
            final dignity = (planet['dignity'] ?? '').toString().toLowerCase();
            var flagStr = '';
            if (flags.contains('R')) flagStr += '*';
            if (flags.contains('C')) flagStr += '^';
            if (flags.contains('V')) flagStr += '\u25A1';
            if (dignity == 'exalted') flagStr += '\u2191';
            if (dignity == 'debilitated') flagStr += '\u2193';
            final abbr = name.length > 2 ? name.substring(0, 2) : name;
            return Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: abbr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (flagStr.isNotEmpty)
                  TextSpan(
                    text: flagStr,
                    style: TextStyle(color: const Color(0xFFE0A526), fontSize: fontSize - 2, fontWeight: FontWeight.bold),
                  ),
                TextSpan(
                  text: '$degree',
                  style: TextStyle(color: Colors.white70, fontSize: fontSize - 3),
                ),
              ]),
            );
          }),
      ],
    ));
  }

  Widget _legend() {
    const style = TextStyle(color: AppColors.textSecondary, fontSize: 10);
    const boldStyle = TextStyle(color: AppColors.textPrimary, fontSize: 10, fontWeight: FontWeight.w600);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: const Wrap(
        spacing: 16,
        runSpacing: 4,
        children: [
          Row(mainAxisSize: MainAxisSize.min, children: [Text('* ', style: boldStyle), Text(AppLocalizations.of(context)?.retrograde ?? 'Retrograde', style: style)]),
          Row(mainAxisSize: MainAxisSize.min, children: [Text('^ ', style: boldStyle), Text(AppLocalizations.of(context)?.combust ?? 'Combust', style: style)]),
          Row(mainAxisSize: MainAxisSize.min, children: [Text('\u25A1 ', style: boldStyle), Text(AppLocalizations.of(context)?.vargottama ?? 'Vargottama', style: style)]),
          Row(mainAxisSize: MainAxisSize.min, children: [Text('\u2191 ', style: boldStyle), Text(AppLocalizations.of(context)?.exalted ?? 'Exalted', style: style)]),
          Row(mainAxisSize: MainAxisSize.min, children: [Text('\u2193 ', style: boldStyle), Text(AppLocalizations.of(context)?.debilitated ?? 'Debilitated', style: style)]),
        ],
      ),
    );
  }
}


/// Draws the North Indian chart geometry:
/// outer square → diamond (connecting midpoints) → diagonals splitting corners.
class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()
      ..color = const Color(0xFFE0A526)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Key points
    final a = Offset(0, 0);
    final b = Offset(w, 0);
    final c = Offset(w, h);
    final d = Offset(0, h);
    final e = Offset(w / 2, 0);
    final f = Offset(w, h / 2);
    final g = Offset(w / 2, h);
    final hh = Offset(0, h / 2);

    // Outer square
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paint);

    // Diamond (connecting midpoints)
    final diamond = Path()
      ..moveTo(e.dx, e.dy)
      ..lineTo(f.dx, f.dy)
      ..lineTo(g.dx, g.dy)
      ..lineTo(hh.dx, hh.dy)
      ..close();
    canvas.drawPath(diamond, paint);

    // Diagonals of outer square (create the 12 houses by splitting corners)
    canvas.drawLine(a, c, paint);
    canvas.drawLine(b, d, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
