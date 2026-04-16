import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

/// North-Indian style kundli grid — 4x4 with diamond houses.
/// Houses is a list of 12 house maps from API, ordered from H1 (lagna).
///
/// North Indian layout:
///    +----+----+----+----+
///    | 12 |  1 |  2 |  3 |
///    +----+----+----+----+
///    | 11 | [center] |  4 |
///    +----+          +----+
///    | 10 |          |  5 |
///    +----+----+----+----+
///    |  9 |  8 |  7 |  6 |
///    +----+----+----+----+
///
/// Traditional North Indian kundli uses a square divided into 12
/// triangular/diamond cells. For simplicity, we use a 4x4 grid.
class KundliGridWidget extends StatelessWidget {
  final List<dynamic> houses;
  final double? size;

  const KundliGridWidget({super.key, required this.houses, this.size});

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
    final cellSize = side / 4;

    // Diamond layout: indices per cell position in 4x4 grid
    // Layout as list of (house_num_or_0) for 16 cells
    // 0 = merged/center cell, handled separately
    // Top row:     [12, 1, 2, 3]
    // Middle-up:   [11, ?, ?, 4]  (middle two are diagonals)
    // Middle-dn:   [10, ?, ?, 5]
    // Bottom:      [9,  8, 7, 6]
    const layout = [
      12, 1, 2, 3,
      11, 0, 0, 4,
      10, 0, 0, 5,
      9, 8, 7, 6,
    ];

    return Container(
      width: side,
      height: side,
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 1.5),
      ),
      child: Stack(children: [
        // Draw 4x4 cells (outer houses)
        for (int i = 0; i < 16; i++)
          if (layout[i] != 0)
            Positioned(
              left: (i % 4) * cellSize,
              top: (i ~/ 4) * cellSize,
              width: cellSize,
              height: cellSize,
              child: _cell(_house(layout[i])),
            ),
        // Center 2x2 split into 4 triangular houses (1, 4, 7, 10 are in corners already — center shows 4 more houses?)
        // Actually in North Indian, lagna is in center top. Our layout above has H1 at top-center-left.
        // Let's draw a big "center" marker
        Positioned(
          left: cellSize,
          top: cellSize,
          width: cellSize * 2,
          height: cellSize * 2,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.star, color: AppColors.primary.withOpacity(0.6), size: 28),
                const SizedBox(height: 6),
                Text('Lagna\n${_house(1)?['rashi_short'] ?? ''}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700)),
              ]),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _cell(Map<String, dynamic>? house) {
    if (house == null) return const SizedBox.shrink();
    final isLagna = house['is_lagna'] == true;
    final planets = (house['planets'] as List?) ?? [];

    return Container(
      decoration: BoxDecoration(
        color: isLagna ? AppColors.primary.withOpacity(0.1) : AppColors.card,
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      padding: const EdgeInsets.all(4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${house['house']}',
              style: TextStyle(
                  color: isLagna ? AppColors.primary : AppColors.textSecondary,
                  fontSize: 10, fontWeight: FontWeight.bold)),
          Text('${house['rashi_short']}',
              style: TextStyle(
                  color: isLagna ? AppColors.primary : AppColors.textSecondary,
                  fontSize: 10, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 2),
        Expanded(
          child: Wrap(
            spacing: 3,
            runSpacing: 2,
            children: planets.map<Widget>((p) {
              final planet = p as Map;
              final name = (planet['planet'] ?? '').toString();
              final flags = (planet['flags'] as List?)?.join('') ?? '';
              return Text(
                '${name.substring(0, 2)}$flags',
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 10, fontWeight: FontWeight.w600),
              );
            }).toList(),
          ),
        ),
      ]),
    );
  }
}
