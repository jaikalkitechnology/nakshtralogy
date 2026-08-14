import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/premium_ui.dart';
import '../../../shared/responsive.dart';

/// Birth date / time / place editor — relocated here from the signup Complete
/// Profile screen (spec §2 trimmed signup to name + contact). These fields
/// power the Kundli / Cosmic Insights features, so they stay editable from
/// Profile → Birth details at any time. Saves via `PATCH /me`.
class BirthDetailsScreen extends StatefulWidget {
  const BirthDetailsScreen({super.key});

  @override
  State<BirthDetailsScreen> createState() => _BirthDetailsScreenState();
}

class _BirthDetailsScreenState extends State<BirthDetailsScreen> {
  final _place = TextEditingController();
  DateTime? _dob;
  TimeOfDay? _time;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Prefill from the session user ("YYYY-MM-DD" / "HH:MM[:SS]").
    final user = getIt<AuthCubit>().state.user;
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

  @override
  void dispose() {
    _place.dispose();
    super.dispose();
  }

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

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    if (_dob == null) {
      setState(() => _error = l.birthDobRequired);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final user = await getIt<AuthRepository>().updateProfile({
        'dob': _dob!.toIso8601String().split('T').first,
        if (_time != null)
          'birth_time':
              '${_time!.hour.toString().padLeft(2, '0')}:${_time!.minute.toString().padLeft(2, '0')}:00',
        if (_place.text.trim().isNotEmpty) 'birth_place': _place.text.trim(),
      });
      getIt<AuthCubit>().updateUser(user);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.birthSaved)));
      Navigator.of(context).pop();
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.borderSoft),
    );
    return Scaffold(
      appBar: AppBar(title: Text(l.profileBirthDetails)),
      body: SafeArea(
        child: CenteredMaxWidth(
          maxWidth: Responsive.readableMaxWidth,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.birthDetailsSubtitle,
                    style: AppTextStyles.body(color: AppColors.ivoryDim)),
                const SectionLabel('Date & time of birth'),
                _PickerTile(
                  label: l.birthDob,
                  value: _dob == null
                      ? l.birthSelect
                      : _dob!.toIso8601String().split('T').first,
                  icon: Icons.cake_outlined,
                  onTap: _pickDob,
                ),
                const SizedBox(height: 12),
                _PickerTile(
                  label: l.birthTimeOptional,
                  value: _time == null ? l.birthSelect : _time!.format(context),
                  icon: Icons.schedule,
                  onTap: _pickTime,
                ),
                const SectionLabel('Place of birth'),
                PremiumCard(
                  child: TextField(
                    controller: _place,
                    style: AppTextStyles.body(size: 15, color: AppColors.ivory),
                    cursorColor: AppColors.saffron,
                    decoration: InputDecoration(
                      labelText: l.birthPlaceOptional,
                      labelStyle:
                          AppTextStyles.label(size: 13.5, color: AppColors.gold),
                      floatingLabelStyle: AppTextStyles.label(
                          size: 13.5,
                          weight: FontWeight.w700,
                          color: AppColors.saffron),
                      filled: true,
                      fillColor: AppColors.surface1,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      enabledBorder: border,
                      border: border,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: AppColors.saffron, width: 1.6),
                      ),
                    ),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 14),
                  Text(_error!,
                      style: AppTextStyles.body(size: 13, color: AppColors.danger)),
                ],
                const SizedBox(height: 28),
                PremiumPrimaryButton(
                  label: l.commonSave,
                  icon: Icons.check_rounded,
                  onPressed: _saving ? null : _save,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile(
      {required this.label, required this.value, required this.icon, required this.onTap});
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          IconTile(icon, tone: TileTone.gold, size: 42),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label(size: 12, color: AppColors.gold)),
                const SizedBox(height: 3),
                Text(value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body(size: 15, color: AppColors.ivory)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: AppColors.ivoryFaint, size: 20),
        ],
      ),
    );
  }
}
