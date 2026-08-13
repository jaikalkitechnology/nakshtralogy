import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

import '../../../l10n/app_localizations.dart';

/// Lazy per-tab loader: shows a spinner while the section fetches, an error +
/// retry on failure, and hands the parsed `data` map to [builder] on success.
/// Keeps its state alive across tab switches (fetch once). If [initial] is
/// supplied (seeded from the prefetched `/analysis/complete`) it renders
/// immediately with no network round-trip.
class SectionLoader extends StatefulWidget {
  const SectionLoader({super.key, this.initial, this.loader, required this.builder});

  final Map<String, dynamic>? initial;
  final Future<Map<String, dynamic>> Function()? loader;
  final Widget Function(BuildContext, Map<String, dynamic>) builder;

  @override
  State<SectionLoader> createState() => _SectionLoaderState();
}

class _SectionLoaderState extends State<SectionLoader>
    with AutomaticKeepAliveClientMixin {
  Map<String, dynamic>? _data;
  bool _loading = false;
  String? _error;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null && widget.initial!.isNotEmpty) {
      _data = widget.initial;
    } else if (widget.loader != null) {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await widget.loader!();
      if (!mounted) return;
      setState(() {
        _data = data;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = AppLocalizations.of(context).commonErrorGeneric;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l = AppLocalizations.of(context);
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.saffron));
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppColors.danger, size: 40),
              const SizedBox(height: 12),
              Text(_error!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body(color: AppColors.ivoryDim)),
              const SizedBox(height: 14),
              ElevatedButton(onPressed: _load, child: Text(l.kunRetry)),
            ],
          ),
        ),
      );
    }
    final data = _data;
    if (data == null || data.isEmpty) {
      return Center(
        child: Text(l.kunNoData,
            style: AppTextStyles.body(color: AppColors.ivoryFaint)),
      );
    }
    return widget.builder(context, data);
  }
}

/// Glassy section card: copper title, optional subtitle, surface1 fill.
class KundliSectionCard extends StatelessWidget {
  const KundliSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.icon,
    this.trailing,
  });

  final String title;
  final Widget child;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: AppColors.copperLight, size: 18),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(title,
                    style: AppTextStyles.label(
                        size: 13, color: AppColors.copperLight)),
              ),
              ?trailing,
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 3),
            Text(subtitle!,
                style: AppTextStyles.body(size: 11.5, color: AppColors.ivoryFaint)),
          ],
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// A labelled saffron progress bar with a trailing value chip.
class ScoreBar extends StatelessWidget {
  const ScoreBar({
    super.key,
    required this.label,
    required this.value,
    this.max = 100,
    this.color,
    this.valueText,
  });

  final String label;
  final double value;
  final double max;
  final Color? color;
  final String? valueText;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.saffron;
    final fraction = max > 0 ? (value / max).clamp(0.0, 1.0) : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body(size: 12, color: AppColors.ivoryDim)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 7,
                backgroundColor: AppColors.surface2,
                valueColor: AlwaysStoppedAnimation<Color>(c),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 42,
            child: Text(valueText ?? value.toStringAsFixed(0),
                textAlign: TextAlign.right,
                style: AppTextStyles.mono(
                    size: 12, weight: FontWeight.w700, color: AppColors.gold)),
          ),
        ],
      ),
    );
  }
}

/// Small pill/badge (copper outline by default).
class KundliBadge extends StatelessWidget {
  const KundliBadge({super.key, required this.text, this.color});
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.copperLight;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.withValues(alpha: 0.4)),
      ),
      child: Text(text,
          style: AppTextStyles.label(size: 10.5, color: c)),
    );
  }
}

/// Per-planet accent colour for dots / avatars.
Color kundliPlanetColor(String planet) {
  switch (planet) {
    case 'Sun':
      return AppColors.saffron;
    case 'Moon':
      return AppColors.ivoryDim;
    case 'Mars':
      return AppColors.danger;
    case 'Mercury':
      return AppColors.success;
    case 'Jupiter':
      return AppColors.gold;
    case 'Venus':
      return AppColors.copperLight;
    case 'Saturn':
      return AppColors.info;
    case 'Rahu':
      return AppColors.indigoSoft;
    case 'Ketu':
      return AppColors.copper;
    default:
      return AppColors.saffron;
  }
}

/// Grade colour from a 0..[max] score: danger → gold → success.
Color kundliGradeColor(double score, {double max = 100}) {
  final pct = max > 0 ? score / max : 0;
  if (pct >= 0.75) return AppColors.success;
  if (pct >= 0.5) return AppColors.gold;
  if (pct >= 0.3) return AppColors.saffron;
  return AppColors.danger;
}

const kundliPlanetSymbols = {
  'Sun': '☉', 'Moon': '☾', 'Mars': '♂', 'Mercury': '☿', 'Jupiter': '♃',
  'Venus': '♀', 'Saturn': '♄', 'Rahu': '☊', 'Ketu': '☋', 'Lagna': 'La',
};
