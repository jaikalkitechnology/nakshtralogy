import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../insights_repository.dart';

/// The birth-identity fields an insight can require.
enum InsightField { name, gender, dob, time, place }

/// A partner's birth identity for the love-match request (not persisted).
class PartnerDetails {
  const PartnerDetails({
    required this.name,
    required this.gender,
    required this.dob,
    this.time,
    this.place,
    this.language,
  });

  final String name;
  final String gender; // "male" | "female" | "other"
  final String dob; // YYYY-MM-DD
  final String? time; // HH:MM
  final String? place;

  /// The language the seeker wants THIS report generated in (e.g. "hi", "ta").
  /// Sent to the backend as a per-request Accept-Language so the Cosmic
  /// Services response comes back in that language, independent of the app's
  /// UI language. Null → use the app's current language.
  final String? language;

  Map<String, dynamic> toJson() => {
        'name': name,
        'gender': gender,
        'dob': dob,
        if (time != null) 'time': time,
        if (place != null) 'place': place,
      };
}

/// Which of [required] the session user is still missing.
Set<InsightField> missingInsightFields(AppUser? user, Set<InsightField> required) {
  bool blank(String? s) => s == null || s.trim().isEmpty;
  return {
    for (final f in required)
      if (switch (f) {
        InsightField.name => blank(user?.name),
        InsightField.gender => blank(user?.gender),
        InsightField.dob => blank(user?.dob),
        InsightField.time => blank(user?.birthTime),
        InsightField.place => blank(user?.birthPlace),
      })
        f,
  };
}

/// Pre-flight sheet shown when the profile lacks fields an insight needs.
/// Shows only the missing fields, saves them back to the profile via the
/// existing `PATCH /me` path, and resolves to true once saved.
Future<bool> showInsightPreflight(
  BuildContext context, {
  required Set<InsightField> missing,
}) async {
  final saved = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: AppColors.indigoDeep,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _DetailsForm(fields: missing, mode: _FormMode.saveProfile),
  );
  return saved == true;
}

/// The generate-details sheet shown for EVERY insight generation: all the
/// fields the service needs, pre-filled from the profile but fully editable
/// (so a report can be generated for someone else), returning the values on
/// the explicit Generate tap. Nothing is saved to the profile and no API
/// call happens until (or unless) the user taps Generate. Resolves to null
/// when dismissed.
Future<PartnerDetails?> showGenerateDetailsSheet(
  BuildContext context, {
  required Set<InsightField> fields,
}) {
  return showModalBottomSheet<PartnerDetails>(
    context: context,
    backgroundColor: AppColors.indigoDeep,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _DetailsForm(fields: fields, mode: _FormMode.generate),
  );
}

/// Collects the partner's birth details for the love match. Resolves to null
/// when dismissed.
Future<PartnerDetails?> showPartnerDetailsSheet(BuildContext context) {
  return showModalBottomSheet<PartnerDetails>(
    context: context,
    backgroundColor: AppColors.indigoDeep,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const _DetailsForm(
      fields: {
        InsightField.name,
        InsightField.gender,
        InsightField.dob,
        InsightField.time,
        InsightField.place,
      },
      mode: _FormMode.partner,
    ),
  );
}

enum _FormMode {
  /// Edit the seeker's own profile: prefilled, saved via PATCH /me,
  /// resolves true.
  saveProfile,

  /// Collect a partner's details (blank) and just return them.
  partner,

  /// Generate-details: prefilled from the profile, fully editable, returns
  /// the values WITHOUT saving anything to the profile.
  generate,
}

class _DetailsForm extends StatefulWidget {
  const _DetailsForm({required this.fields, required this.mode});

  final Set<InsightField> fields;
  final _FormMode mode;

  @override
  State<_DetailsForm> createState() => _DetailsFormState();
}

// Report languages the user can generate in — code → localized native label.
// The label is resolved from the existing AppLocalizations `language*` keys so
// it stays translated without new ARB entries.
const List<String> _kReportLangCodes = [
  'en', 'hi', 'bn', 'gu', 'kn', 'ml', 'mr', 'pa', 'ta', 'te',
];

String _reportLangLabel(AppLocalizations l, String code) => switch (code) {
      'hi' => l.languageHindi,
      'bn' => l.languageBengali,
      'gu' => l.languageGujarati,
      'kn' => l.languageKannada,
      'ml' => l.languageMalayalam,
      'mr' => l.languageMarathi,
      'pa' => l.languagePunjabi,
      'ta' => l.languageTamil,
      'te' => l.languageTelugu,
      _ => l.languageEnglish,
    };

class _DetailsFormState extends State<_DetailsForm> {
  final _name = TextEditingController();
  final _place = TextEditingController();
  String? _gender;
  DateTime? _dob;
  TimeOfDay? _time;
  String? _language; // report language; defaults to the app locale in build
  bool _saving = false;
  String? _error;

  // Birth-place autocomplete (Nominatim city search, same as the Nakshatralogy
  // app). Debounced so we don't hit the API on every keystroke.
  Timer? _placeDebounce;
  List<Map<String, dynamic>> _placeSuggestions = const [];
  bool _placeSearching = false;

  void _onPlaceChanged(String q) {
    setState(() {}); // keep the Generate button's enable-state in sync
    _placeDebounce?.cancel();
    final query = q.trim();
    if (query.length < 3) {
      setState(() => _placeSuggestions = const []);
      return;
    }
    _placeDebounce = Timer(const Duration(milliseconds: 400), () async {
      setState(() => _placeSearching = true);
      final results = await getIt<InsightsRepository>().citySearch(query);
      if (!mounted) return;
      setState(() {
        _placeSuggestions = results;
        _placeSearching = false;
      });
    });
  }

  void _pickPlace(Map<String, dynamic> city) {
    final label = (city['display_name'] ?? city['name'] ?? '').toString();
    _place.text = label;
    FocusScope.of(context).unfocus();
    setState(() => _placeSuggestions = const []);
  }

  bool _has(InsightField f) => widget.fields.contains(f);

  /// The language selector is offered on the generate sheet (the report the
  /// user is about to read). Not on the save-profile sheet (just editing
  /// fields), nor the partner sheet (the language was already chosen on the
  /// seeker's generate sheet for the love-match report).
  bool get _showLanguage => widget.mode == _FormMode.generate;

  @override
  void initState() {
    super.initState();
    if (widget.mode != _FormMode.partner) {
      // Prefill whatever the profile already has (generate mode shows the
      // full field set pre-filled; profile mode usually opens blank since
      // it only shows missing fields, but keep it robust).
      final user = getIt<AuthCubit>().state.user;
      _name.text = user?.name ?? '';
      _gender = user?.gender;
      _dob = user?.dob == null ? null : DateTime.tryParse(user!.dob!);
      final t = user?.birthTime;
      if (t != null) {
        final parts = t.split(':');
        final h = int.tryParse(parts[0]);
        final m = parts.length > 1 ? int.tryParse(parts[1]) : null;
        if (h != null && m != null) _time = TimeOfDay(hour: h, minute: m);
      }
      _place.text = user?.birthPlace ?? '';
    }
  }

  @override
  void dispose() {
    _placeDebounce?.cancel();
    _name.dispose();
    _place.dispose();
    super.dispose();
  }

  String get _dobStr => _dob!.toIso8601String().split('T').first;
  String get _timeStr =>
      '${_time!.hour.toString().padLeft(2, '0')}:${_time!.minute.toString().padLeft(2, '0')}';

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(1995),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (t != null) setState(() => _time = t);
  }

  bool get _complete =>
      (!_has(InsightField.name) || _name.text.trim().isNotEmpty) &&
      (!_has(InsightField.gender) || _gender != null) &&
      (!_has(InsightField.dob) || _dob != null) &&
      (!_has(InsightField.time) || _time != null) &&
      (!_has(InsightField.place) || _place.text.trim().isNotEmpty);

  Future<void> _submit() async {
    final l = AppLocalizations.of(context);
    if (!_complete) {
      setState(() => _error = l.insightFieldsRequired);
      return;
    }
    if (widget.mode != _FormMode.saveProfile) {
      // partner + generate modes just hand the values back — nothing is
      // written to the profile, and the caller fires the API only now.
      Navigator.of(context).pop(PartnerDetails(
        name: _name.text.trim(),
        gender: _gender!,
        dob: _dobStr,
        time: _time == null ? null : _timeStr,
        place: _place.text.trim().isEmpty ? null : _place.text.trim(),
        language: _language ?? Localizations.localeOf(context).languageCode,
      ));
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final user = await getIt<AuthRepository>().updateProfile({
        if (_has(InsightField.name)) 'name': _name.text.trim(),
        if (_has(InsightField.gender)) 'gender': _gender,
        if (_has(InsightField.dob)) 'dob': _dobStr,
        if (_has(InsightField.time)) 'birth_time': '$_timeStr:00',
        if (_has(InsightField.place)) 'birth_place': _place.text.trim(),
      });
      getIt<AuthCubit>().updateUser(user);
      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final genders = [
      ('male', l.genderMale),
      ('female', l.genderFemale),
      ('other', l.genderOther),
    ];
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              switch (widget.mode) {
                _FormMode.partner => l.insightPartnerTitle,
                _FormMode.generate => l.insightGenerateTitle,
                _FormMode.saveProfile => l.insightPreflightTitle,
              },
              style: AppTextStyles.heading(size: 20),
            ),
            const SizedBox(height: 4),
            Text(
              switch (widget.mode) {
                _FormMode.partner => l.insightPartnerSubtitle,
                _FormMode.generate => l.insightGenerateSubtitle,
                _FormMode.saveProfile => l.insightPreflightSubtitle,
              },
              style: AppTextStyles.body(size: 13, color: AppColors.ivoryDim),
            ),
            const SizedBox(height: 20),
            if (_has(InsightField.name)) ...[
              TextField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(labelText: l.insightFieldName),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 14),
            ],
            if (_has(InsightField.gender)) ...[
              Text(l.insightFieldGender,
                  style: AppTextStyles.label(size: 12, color: AppColors.ivoryDim)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final (value, label) in genders)
                    ChoiceChip(
                      label: Text(label),
                      selected: _gender == value,
                      selectedColor: AppColors.saffron,
                      onSelected: (_) => setState(() => _gender = value),
                    ),
                ],
              ),
              const SizedBox(height: 14),
            ],
            if (_has(InsightField.dob)) ...[
              _PickerTile(
                label: l.insightFieldDob,
                value: _dob == null ? l.birthSelect : _dobStr,
                icon: Icons.cake_outlined,
                onTap: _pickDob,
              ),
              const SizedBox(height: 14),
            ],
            if (_has(InsightField.time)) ...[
              _PickerTile(
                label: l.insightFieldBirthTime,
                value: _time == null ? l.birthSelect : _time!.format(context),
                icon: Icons.schedule,
                onTap: _pickTime,
              ),
              const SizedBox(height: 14),
            ],
            if (_has(InsightField.place)) ...[
              TextField(
                controller: _place,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l.insightFieldBirthPlace,
                  prefixIcon: const Icon(Icons.location_on_outlined, size: 20),
                  suffixIcon: _placeSearching
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2)),
                        )
                      : null,
                ),
                onChanged: _onPlaceChanged,
              ),
              if (_placeSuggestions.isNotEmpty) ...[
                const SizedBox(height: 6),
                Container(
                  constraints: const BoxConstraints(maxHeight: 220),
                  decoration: BoxDecoration(
                    color: AppColors.surface1,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderSoft),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _placeSuggestions.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: AppColors.borderSoft),
                    itemBuilder: (context, i) {
                      final c = _placeSuggestions[i];
                      final label =
                          (c['display_name'] ?? c['name'] ?? '').toString();
                      return ListTile(
                        dense: true,
                        leading: const Icon(Icons.place_outlined,
                            size: 18, color: AppColors.copperLight),
                        title: Text(label,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body(size: 13)),
                        onTap: () => _pickPlace(c),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 14),
            ],
            if (_showLanguage) ...[
              Row(
                children: [
                  const Icon(Icons.translate,
                      size: 16, color: AppColors.copperLight),
                  const SizedBox(width: 6),
                  Text(l.profileLanguage,
                      style: AppTextStyles.label(
                          size: 12, color: AppColors.ivoryDim)),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface1,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSoft),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _language ?? Localizations.localeOf(context).languageCode,
                    dropdownColor: AppColors.indigoDeep,
                    icon: Icon(Icons.expand_more, color: AppColors.ivoryDim),
                    style: AppTextStyles.body(size: 14, color: AppColors.ivory),
                    items: [
                      for (final code in _kReportLangCodes)
                        DropdownMenuItem(
                          value: code,
                          child: Text(_reportLangLabel(l, code)),
                        ),
                    ],
                    onChanged: (v) => setState(() => _language = v),
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],
            if (_error != null) ...[
              Text(_error!,
                  style: AppTextStyles.body(size: 13, color: AppColors.danger)),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _submit,
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(switch (widget.mode) {
                        _FormMode.partner => l.authContinue,
                        _FormMode.generate => l.insightGenerateCta,
                        _FormMode.saveProfile => l.commonSave,
                      }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.copperLight, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body(color: AppColors.ivoryDim)),
            ),
            Text(value, style: AppTextStyles.body(color: AppColors.ivory)),
          ],
        ),
      ),
    );
  }
}
