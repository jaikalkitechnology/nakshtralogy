import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../../theme/app_theme.dart';

/// Shared base widget that loads a section lazily or uses the initial data.
class SectionLoader extends StatefulWidget {
  final Map<String, dynamic>? initial;
  final Future<Map<String, dynamic>> Function()? loader;
  final Widget Function(BuildContext, Map<String, dynamic>) builder;

  const SectionLoader({super.key, this.initial, this.loader, required this.builder});

  @override
  State<SectionLoader> createState() => _SectionLoaderState();
}

class _SectionLoaderState extends State<SectionLoader> with AutomaticKeepAliveClientMixin {
  Map<String, dynamic>? _data;
  bool _loading = false;
  String? _error;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.initial is Map) {
      _data = widget.initial;
    } else if (widget.loader != null) {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final resp = await widget.loader!();
      if (resp['statusCode'] == 200 && resp['status'] == 'success') {
        setState(() { _data = (resp['data'] as Map).cast<String, dynamic>(); _loading = false; });
      } else {
        setState(() { _error = resp['detail']?.toString() ?? 'Failed'; _loading = false; });
      }
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_loading) return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    if (_error != null) {
      return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.error_outline, color: AppColors.error, size: 40),
        const SizedBox(height: 12),
        Text(_error!, style: const TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: _load, child: Text(AppLocalizations.of(context)?.retry ?? 'Retry')),
      ]));
    }
    if (_data == null) return const Center(child: Text('No data', style: TextStyle(color: AppColors.textSecondary)));
    return widget.builder(context, _data!);
  }
}

class KundliSectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final String? subtitle;
  final IconData? icon;
  final Color? color;

  const KundliSectionCard({super.key, required this.title, required this.child, this.subtitle, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          if (icon != null) ...[Icon(icon, color: c, size: 18), const SizedBox(width: 8)],
          Expanded(child: Text(title, style: TextStyle(color: c, fontWeight: FontWeight.w700, fontSize: 14))),
        ]),
        if (subtitle != null) ...[const SizedBox(height: 2), Text(subtitle!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11))],
        const SizedBox(height: 10),
        child,
      ]),
    );
  }
}
