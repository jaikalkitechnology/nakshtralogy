import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

/// Premium read-only astrologer avatar.
///
/// Shows the astrologer's profile photo when available (resolving relative
/// upload paths and sending auth headers so protected media renders), and
/// otherwise falls back to the first letter of the name on a tasteful,
/// name-deterministic gradient.
class AstroAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double size;
  final bool ring;

  const AstroAvatar({
    super.key,
    required this.imageUrl,
    required this.name,
    this.size = 48,
    this.ring = true,
  });

  static const List<List<Color>> _gradients = [
    [AppColors.gold, AppColors.saffron],
    [AppColors.saffron, AppColors.cosmicPink],
    [AppColors.indigo, AppColors.lavender],
    [AppColors.aurora, AppColors.indigo],
    [AppColors.cosmicPink, AppColors.roseGold],
    [AppColors.lavender, AppColors.cosmicPink],
  ];

  String get _initial {
    final t = name.trim();
    return t.isNotEmpty ? t.substring(0, 1).toUpperCase() : '★';
  }

  List<Color> get _gradient {
    final key = name.trim().isNotEmpty ? name.trim() : '★';
    return _gradients[key.codeUnitAt(0) % _gradients.length];
  }

  @override
  Widget build(BuildContext context) {
    final initial = Center(
      child: Text(
        _initial,
        style: TextStyle(color: Colors.white, fontSize: size * 0.42, fontWeight: FontWeight.w700, fontFamily: 'Manrope'),
      ),
    );

    Widget inner = initial;
    final url = imageUrl;
    if (url != null && url.isNotEmpty) {
      inner = ClipOval(
        child: Image.network(
          ApiService.resolveMediaUrl(url),
          width: size, height: size, fit: BoxFit.cover,
          headers: ApiService().mediaHeadersFor(url),
          loadingBuilder: (ctx, child, p) => p == null ? child : initial,
          errorBuilder: (_, __, ___) => initial,
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: _gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        border: ring ? Border.all(color: AppColors.gold, width: 2) : null,
      ),
      child: inner,
    );
  }
}
