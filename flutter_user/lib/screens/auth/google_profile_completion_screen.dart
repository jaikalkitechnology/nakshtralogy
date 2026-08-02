import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/app_mode.dart';
import '../../services/api_service.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../main.dart';

/// First-time Google users land here after the redirect / native verify: pick
/// region (drives the AppMode language set + currency) and preferred language,
/// then enter the app. Tokens are already stored, so this only enriches the
/// profile — no astrology logic is touched.
class GoogleProfileCompletionScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const GoogleProfileCompletionScreen({super.key, required this.user});

  @override
  State<GoogleProfileCompletionScreen> createState() =>
      _GoogleProfileCompletionScreenState();
}

class _GoogleProfileCompletionScreenState
    extends State<GoogleProfileCompletionScreen> {
  late String _region; // IN | INTL
  late String _langCode;
  bool _saving = false;

  bool _seededFromContext = false;

  @override
  void initState() {
    super.initState();
    _region = AppMode.instance.region;
    _langCode = AppMode.instance.defaultLocaleTag() ?? 'en';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Seed the language from the active locale once (context is ready here).
    if (_seededFromContext) return;
    _seededFromContext = true;
    final loc = Localizations.localeOf(context);
    final tag = loc.scriptCode != null
        ? '${loc.languageCode}_${loc.scriptCode}'
        : loc.languageCode;
    if (_languages.any((o) => o.code == tag)) _langCode = tag;
  }

  List<LangOption> get _languages =>
      _region.toUpperCase() == 'INTL'
          ? AppMode.internationalLanguages
          : AppMode.indianLanguages;

  void _applyLanguage(String code) {
    setState(() => _langCode = code);
    final parts = code.split('_');
    final newLocale = parts.length > 1
        ? Locale.fromSubtags(languageCode: parts[0], scriptCode: parts[1])
        : Locale(code);
    NakshatralogyUserApp.setLocale(context, newLocale);
  }

  Future<void> _onRegionChanged(String region) async {
    setState(() {
      _region = region;
      // Keep the chosen language valid for the new set; else default to English.
      final valid = _languages.any((o) => o.code == _langCode);
      if (!valid) _langCode = 'en';
    });
    await AppMode.instance.setRegion(region);
    _applyLanguage(_langCode);
  }

  Future<void> _finish() async {
    setState(() => _saving = true);
    // Persist region + language to the profile (best-effort; session proceeds
    // regardless so a transient API error never traps a new user).
    Map<String, dynamic> user = widget.user;
    try {
      final res = await ApiService().updateMe({
        'region': _region,
        'language': _langCode,
      });
      if (res['statusCode'] == 200 && res['user'] is Map) {
        user = (res['user'] as Map).cast<String, dynamic>();
      }
    } catch (_) {/* proceed with the stored user */}
    if (!mounted) return;
    context.read<AuthBloc>().add(AuthProfileCompleted(user: user));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final name = (widget.user['name'] ?? widget.user['full_name'] ?? '')
        .toString()
        .split(' ')
        .first;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset('assets/icon/ic_launcher_foreground.png',
                    width: 56, height: 56),
              ),
              const SizedBox(height: 16),
              Text(
                name.isEmpty ? l.awCompleteProfileTitle : l.awWelcomeName(name),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: AppColors.primary, fontSize: 24),
              ),
              const SizedBox(height: 6),
              Text(l.awCompleteProfileSubtitle,
                  style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 28),

              // Region
              Text(l.awRegionLabel,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Row(children: [
                _RegionChip(
                  label: l.awRegionIndia,
                  selected: _region.toUpperCase() != 'INTL',
                  onTap: () => _onRegionChanged('IN'),
                ),
                const SizedBox(width: 12),
                _RegionChip(
                  label: l.awRegionInternational,
                  selected: _region.toUpperCase() == 'INTL',
                  onTap: () => _onRegionChanged('INTL'),
                ),
              ]),
              const SizedBox(height: 24),

              // Preferred language
              Text(l.awPreferredLanguage,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    dropdownColor: AppColors.card,
                    value: _languages.any((o) => o.code == _langCode)
                        ? _langCode
                        : 'en',
                    items: _languages
                        .map((o) => DropdownMenuItem(
                              value: o.code,
                              child: Text('${o.native}  (${o.name})',
                                  style: const TextStyle(
                                      color: AppColors.textPrimary)),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) _applyLanguage(v);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 36),

              ElevatedButton(
                onPressed: _saving ? null : _finish,
                child: _saving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.black))
                    : Text(l.awFinishSetup),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegionChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _RegionChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withOpacity(0.15)
                : AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: selected ? AppColors.primary : AppColors.border),
          ),
          child: Center(
            child: Text(label,
                style: TextStyle(
                    color:
                        selected ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }
}
