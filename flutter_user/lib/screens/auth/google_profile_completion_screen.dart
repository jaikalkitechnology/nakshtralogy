import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/app_mode.dart';
import '../../services/api_service.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../widgets/country_code_picker.dart';
import '../../main.dart';

/// First-time Google users land here after the redirect / native verify. We
/// collect a mandatory phone number (with country code) — this both completes
/// the profile and deterministically seeds the region (IN vs INTL → language
/// set + currency). A preferred language picker follows. Tokens are already
/// stored, so this only enriches the profile — no astrology logic is touched.
class GoogleProfileCompletionScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const GoogleProfileCompletionScreen({super.key, required this.user});

  @override
  State<GoogleProfileCompletionScreen> createState() =>
      _GoogleProfileCompletionScreenState();
}

class _GoogleProfileCompletionScreenState
    extends State<GoogleProfileCompletionScreen> {
  final _phoneCtrl = TextEditingController();
  Country _country = kDefaultCountry;
  late String _langCode;
  bool _saving = false;
  String? _phoneError;

  bool _seededFromContext = false;

  @override
  void initState() {
    super.initState();
    _langCode = AppMode.instance.defaultLocaleTag() ?? 'en';
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Seed the language from the active locale once (context is ready here).
    if (_seededFromContext) return;
    _seededFromContext = true;
    final loc = Localizations.localeOf(context);
    // Resolve to a code that EXISTS in the options (iOS attaches scriptCode:'Latn'
    // to Latin locales, so 'fr_Latn' wouldn't match 'fr').
    final codes = _languages.map((o) => o.code).toSet();
    final lang = loc.languageCode;
    final sc = loc.scriptCode;
    final cc = loc.countryCode;
    final tag = (sc != null && codes.contains('${lang}_$sc'))
        ? '${lang}_$sc'
        : (cc != null && codes.contains('${lang}_$cc'))
            ? '${lang}_$cc'
            : lang;
    if (codes.contains(tag)) _langCode = tag;
  }

  // Region follows the picked country deterministically.
  String get _region => _country.iso == 'IN' ? 'IN' : 'INTL';

  List<LangOption> get _languages =>
      _region == 'INTL' ? AppMode.internationalLanguages : AppMode.indianLanguages;

  void _applyLanguage(String code) {
    setState(() => _langCode = code);
    final parts = code.split('_');
    final newLocale = parts.length > 1
        ? Locale.fromSubtags(languageCode: parts[0], scriptCode: parts[1])
        : Locale(code);
    NakshatralogyUserApp.setLocale(context, newLocale);
  }

  Future<void> _onCountryChanged(Country c) async {
    setState(() {
      _country = c;
      // Keep the chosen language valid for the new set; else default to English.
      if (!_languages.any((o) => o.code == _langCode)) _langCode = 'en';
    });
    await AppMode.instance.setRegion(_region);
    _applyLanguage(_langCode);
  }

  Future<void> _finish() async {
    final local = _phoneCtrl.text.trim().replaceAll(RegExp(r'^0+'), '');
    if (local.length < 6) {
      setState(() => _phoneError = AppLocalizations.of(context)!.required);
      return;
    }
    setState(() { _saving = true; _phoneError = null; });
    final fullPhone = '+${_country.dial}$local';
    // Persist phone + country (seeds region) + language. Best-effort: the
    // session proceeds regardless so a transient API error never traps a new
    // user; the region also lives locally in AppMode.
    Map<String, dynamic> user = widget.user;
    try {
      final res = await ApiService().updateMe({
        'phone': fullPhone,
        'country_code': _country.iso,
        'phone_country_code': '+${_country.dial}',
        'preferred_language': _langCode,
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: AppColors.primary, fontSize: 24),
              ),
              const SizedBox(height: 6),
              Text(l.awCompleteProfileSubtitle,
                  style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 28),

              // Mandatory phone (its country code decides the region).
              Text(l.phone,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(color: AppColors.textPrimary),
                onChanged: (_) => _onCountryChanged(_country),
                decoration: InputDecoration(
                  hintText: l.phone,
                  errorText: _phoneError,
                  prefixIcon: CountryCodePicker(
                    value: _country,
                    onSelected: _onCountryChanged,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Preferred language (set follows the region from the country).
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
