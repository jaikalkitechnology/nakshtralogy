import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
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
                const SizedBox(height: 24),
                _PickerTile(
                  label: l.birthDob,
                  value: _dob == null
                      ? l.birthSelect
                      : _dob!.toIso8601String().split('T').first,
                  icon: Icons.cake_outlined,
                  onTap: _pickDob,
                ),
                const SizedBox(height: 16),
                _PickerTile(
                  label: l.birthTimeOptional,
                  value: _time == null ? l.birthSelect : _time!.format(context),
                  icon: Icons.schedule,
                  onTap: _pickTime,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _place,
                  decoration: InputDecoration(labelText: l.birthPlaceOptional),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 14),
                  Text(_error!,
                      style: AppTextStyles.body(size: 13, color: AppColors.danger)),
                ],
                const SizedBox(height: 28),
                ElevatedButton(
      // Explicit full width: the shared theme no longer forces an
      // (invalid) infinite minimum width on every ElevatedButton.
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(l.commonSave),
                ),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
            const SizedBox(width: 8),
            Flexible(
              child: Text(value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.body(color: AppColors.ivory)),
            ),
          ],
        ),
      ),
    );
  }
}
