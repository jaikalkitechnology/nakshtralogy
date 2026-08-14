import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

/// Shared "premium refresh" building blocks for the astrologer app.
///
/// Presentation only — these are pure styling widgets (gradient cards, gold
/// serif section labels, status chips, gold/saffron icon tiles, a glowing
/// primary button, a sparkline). They carry NO business logic and never own
/// state, so screens can adopt the Nakshatralogy-grade look without any change
/// to their cubits, callbacks, or API calls. All colours come from the brand
/// [AppColors] tokens so the two themes and the design system stay in sync.

/// Gold serif section heading with a trailing hairline — the "Payout method",
/// "Identity", "Account" style labels.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 12),
      child: Row(
        children: [
          Text(text, style: AppTextStyles.heading(size: 15, color: AppColors.gold)),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.gold.withValues(alpha: 0.28), Colors.transparent],
                ),
              ),
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 12), trailing!],
        ],
      ),
    );
  }
}

/// Soft gradient surface card with a faint hairline border — the base surface
/// for grouped rows/content across the refreshed screens.
class PremiumCard extends StatelessWidget {
  const PremiumCard({super.key, required this.child, this.padding, this.onTap});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.surface2, AppColors.surface1],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: child,
    );
    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: card,
      ),
    );
  }
}

enum ChipTone { success, warn, muted, info }

/// Small status pill (verified / pending / not-uploaded / info).
class StatusChip extends StatelessWidget {
  const StatusChip(this.label, {super.key, this.tone = ChipTone.muted, this.icon});

  final String label;
  final ChipTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final (fg, bg, border) = switch (tone) {
      ChipTone.success => (
          AppColors.success,
          AppColors.success.withValues(alpha: 0.12),
          AppColors.success.withValues(alpha: 0.30),
        ),
      ChipTone.warn => (
          AppColors.gold,
          AppColors.gold.withValues(alpha: 0.12),
          AppColors.gold.withValues(alpha: 0.32),
        ),
      ChipTone.info => (
          AppColors.info,
          AppColors.info.withValues(alpha: 0.12),
          AppColors.info.withValues(alpha: 0.28),
        ),
      ChipTone.muted => (
          AppColors.ivoryFaint,
          AppColors.surface2,
          AppColors.borderSoft,
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 12, color: fg), const SizedBox(width: 5)],
          Text(label,
              style: AppTextStyles.label(size: 11, weight: FontWeight.w700, color: fg)),
        ],
      ),
    );
  }
}

enum TileTone { gold, saffron, info }

/// A rounded, softly-glowing icon tile used to lead rows and menu items.
class IconTile extends StatelessWidget {
  const IconTile(this.icon, {super.key, this.tone = TileTone.gold, this.size = 38});

  final IconData icon;
  final TileTone tone;
  final double size;

  @override
  Widget build(BuildContext context) {
    final base = switch (tone) {
      TileTone.gold => AppColors.goldLight,
      TileTone.saffron => AppColors.saffronBright,
      TileTone.info => AppColors.info,
    };
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(-0.4, -0.5),
          radius: 1.1,
          colors: [base.withValues(alpha: 0.26), base.withValues(alpha: 0.06)],
        ),
        borderRadius: BorderRadius.circular(size * 0.32),
        border: Border.all(color: base.withValues(alpha: 0.26)),
      ),
      child: Icon(icon, size: size * 0.48, color: base),
    );
  }
}

/// The one bold action per screen — saffron gradient with a soft glow.
class PremiumPrimaryButton extends StatelessWidget {
  const PremiumPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.height = 54,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Opacity(
      opacity: enabled ? 1 : 0.6,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.saffron.withValues(alpha: 0.45),
                    blurRadius: 26,
                    offset: const Offset(0, 12),
                    spreadRadius: -8,
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Ink(
              height: height,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.saffronBright, AppColors.saffronDeep],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.saffronBright.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 19, color: const Color(0xFF241300)),
                    const SizedBox(width: 9),
                  ],
                  Text(label,
                      style: AppTextStyles.body(
                          size: 15,
                          weight: FontWeight.w800,
                          color: const Color(0xFF241300))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Indigo "hero" surface with a subtle starfield — used for balance / identity
/// headers. Wraps arbitrary [child] content.
class HeroGradientCard extends StatelessWidget {
  const HeroGradientCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.indigoSoft, AppColors.indigoMid, AppColors.indigoDeep],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: AppColors.indigo.withValues(alpha: 0.6),
            blurRadius: 40,
            offset: const Offset(0, 20),
            spreadRadius: -22,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: CustomPaint(
          painter: _StarfieldPainter(),
          child: Padding(padding: padding ?? const EdgeInsets.all(22), child: child),
        ),
      ),
    );
  }
}

/// A handful of faint stars scattered over the hero surface (deterministic,
/// so it never flickers between rebuilds).
class _StarfieldPainter extends CustomPainter {
  static const _points = <(double, double, double, double)>[
    (0.18, 0.30, 1.4, 0.5),
    (0.70, 0.22, 1.2, 0.35),
    (0.42, 0.64, 1.6, 0.30),
    (0.86, 0.68, 1.3, 0.55),
    (0.30, 0.84, 1.3, 0.25),
    (0.60, 0.48, 1.1, 0.3),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final (fx, fy, r, a) in _points) {
      final gold = fx > 0.8;
      final paint = Paint()
        ..color = (gold ? AppColors.gold : AppColors.ivory).withValues(alpha: a);
      canvas.drawCircle(Offset(fx * size.width, fy * size.height), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter oldDelegate) => false;
}

/// A compact area sparkline (normalised 0..1 y-values, left→right), with an
/// emphasised endpoint dot — used on the earnings balance hero.
class Sparkline extends StatelessWidget {
  const Sparkline(this.values, {super.key, this.color, this.width = 88, this.height = 40});

  final List<double> values;
  final Color? color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _SparklinePainter(values, color ?? AppColors.success)),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter(this.values, this.color);

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final minV = values.reduce((a, b) => a < b ? a : b);
    final range = (maxV - minV).abs() < 1e-6 ? 1.0 : (maxV - minV);
    final dx = size.width / (values.length - 1);
    Offset at(int i) => Offset(
          i * dx,
          size.height - ((values[i] - minV) / range) * size.height,
        );

    final line = Path()..moveTo(at(0).dx, at(0).dy);
    for (var i = 1; i < values.length; i++) {
      line.lineTo(at(i).dx, at(i).dy);
    }
    final fill = Path.from(line)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fill, Paint()..color = color.withValues(alpha: 0.14));
    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    final end = at(values.length - 1);
    canvas.drawCircle(end, 3, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
}
