import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/gen/app_localizations.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import 'country_code_picker.dart';

/// One-time mandatory phone capture for existing accounts that have no phone
/// (e.g. older Google signups). The country code seeds the region (IN vs INTL)
/// on the backend. Non-dismissible until a valid number is saved. Returns the
/// updated user map on success, or null if it could not be shown.
class PhoneCaptureSheet {
  static Future<Map<String, dynamic>?> show(BuildContext context) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _PhoneCaptureBody(),
    );
  }
}

class _PhoneCaptureBody extends StatefulWidget {
  const _PhoneCaptureBody();
  @override
  State<_PhoneCaptureBody> createState() => _PhoneCaptureBodyState();
}

class _PhoneCaptureBodyState extends State<_PhoneCaptureBody> {
  final _phoneCtrl = TextEditingController();
  Country _country = kDefaultCountry;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final local = _phoneCtrl.text.trim().replaceAll(RegExp(r'^0+'), '');
    if (local.length < 6) {
      setState(() => _error = AppLocalizations.of(context)!.required);
      return;
    }
    setState(() { _saving = true; _error = null; });
    final fullPhone = '+${_country.dial}$local';
    try {
      final res = await ApiService().updateMe({
        'phone': fullPhone,
        'country_code': _country.iso,
      });
      if (!mounted) return;
      if (res['statusCode'] == 200) {
        Navigator.pop(context, (res['user'] as Map?)?.cast<String, dynamic>() ?? {});
        return;
      }
      setState(() => _error = res['detail']?.toString() ?? 'Could not save');
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    }
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.phone_android, color: AppColors.primary, size: 40),
        const SizedBox(height: 12),
        Text('Add your phone number',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        const Text('We need a verified phone number to keep your account secure and to set your region.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 20),
        TextField(
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: l.phone,
            errorText: _error,
            prefixIcon: CountryCodePicker(
              value: _country,
              onSelected: (c) => setState(() => _country = c),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
              : Text(l.awFinishSetup),
        )),
      ]),
    );
  }
}
