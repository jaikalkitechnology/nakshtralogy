import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

/// The deep-indigo radial gradient canvas used on every screen.
class CosmicBackground extends StatelessWidget {
  const CosmicBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.currentBrightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.7, -0.9),
          radius: 1.4,
          colors: [
            isDark ? const Color(0xFF241F56) : const Color(0xFFFFF1DC),
            AppColors.indigoVoid,
          ],
          stops: const [0.0, 0.6],
        ),
      ),
      child: child,
    );
  }
}

/// The diya (lamp) brand mark.
class DiyaLogo extends StatelessWidget {
  const DiyaLogo({super.key, this.size = 72});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.saffron, AppColors.gold],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: AppColors.saffron.withValues(alpha: 0.4), blurRadius: 28, spreadRadius: 2),
        ],
      ),
      child: Icon(Icons.local_fire_department, size: size * 0.5, color: AppColors.indigoVoid),
    );
  }
}
