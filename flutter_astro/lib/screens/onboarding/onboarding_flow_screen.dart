import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../services/api_service.dart';

/// Post-login onboarding for astrologers: Step 1 Personal info (mobile number
/// mandatory) → Step 2 Professional info. KYC follows this in the HomeScreen
/// gate, giving the required order: personal → professional → KYC.
class OnboardingFlowScreen extends StatefulWidget {
  /// Called once professional info is saved so the gate can advance to KYC.
  final VoidCallback onComplete;
  const OnboardingFlowScreen({super.key, required this.onComplete});

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  final _api = ApiService();
  final _pageController = PageController();
  int _step = 0;
  bool _loading = true;
  bool _saving = false;

  // Step 1 — personal
  final _personalKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String? _gender;

  // Step 2 — professional
  final _professionalKey = GlobalKey<FormState>();
  final _displayNameCtrl = TextEditingController();
  final _expCtrl = TextEditingController();
  final _qualCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();

  // Backend enum values — not localized.
  final List<String> _allLanguages = ['Hindi', 'English', 'Sanskrit', 'Gujarati', 'Marathi', 'Tamil', 'Telugu', 'Bengali'];
  final List<String> _allSpecs = ['Vedic Astrology', 'Numerology', 'Tarot', 'Palmistry', 'Vastu Shastra', 'Kundli Matching', 'Horoscope'];
  final Set<String> _selectedLangs = {};
  final Set<String> _selectedSpecs = {};

  @override
  void initState() {
    super.initState();
    _prefill();
  }

  Future<void> _prefill() async {
    try {
      final me = await _api.getMe();
      if (me['statusCode'] == 200) {
        final user = (me['user'] ?? me) as Map<String, dynamic>;
        _nameCtrl.text = (user['name'] ?? '').toString();
        _phoneCtrl.text = (user['phone'] ?? '').toString();
        _gender = (user['gender'] as String?)?.isNotEmpty == true ? user['gender'] as String? : null;
        final p = user['profile'] as Map<String, dynamic>?;
        if (p != null) {
          _displayNameCtrl.text = (p['display_name'] ?? user['name'] ?? '').toString();
          final exp = p['experience_years'];
          if (exp != null && exp != 0) _expCtrl.text = exp.toString();
          _qualCtrl.text = (p['qualification'] ?? '').toString();
          _bioCtrl.text = (p['bio'] ?? '').toString();
          for (final e in (p['languages'] as List? ?? [])) {
            if (_allLanguages.contains(e)) _selectedLangs.add(e as String);
          }
          for (final e in (p['specializations'] as List? ?? [])) {
            if (_allSpecs.contains(e)) _selectedSpecs.add(e as String);
          }
        }
        if (_displayNameCtrl.text.isEmpty) _displayNameCtrl.text = _nameCtrl.text;
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _displayNameCtrl.dispose();
    _expCtrl.dispose();
    _qualCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _savePersonal() async {
    if (!_personalKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final resp = await _api.updateMeFields({
        'name': _nameCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        if (_gender != null) 'gender': _gender,
      });
      if (!mounted) return;
      if (resp['statusCode'] == 200) {
        setState(() => _step = 1);
        _pageController.animateToPage(1, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      } else {
        _err(resp['detail']?.toString() ?? 'Could not save personal info');
      }
    } catch (e) {
      _err('Error: $e');
    }
    if (mounted) setState(() => _saving = false);
  }

  Future<void> _saveProfessional() async {
    if (!_professionalKey.currentState!.validate()) return;
    if (_selectedLangs.isEmpty || _selectedSpecs.isEmpty) {
      _err('Select at least one language and one specialization');
      return;
    }
    setState(() => _saving = true);
    try {
      final resp = await _api.updateProfile({
        'display_name': _displayNameCtrl.text.trim().isNotEmpty ? _displayNameCtrl.text.trim() : _nameCtrl.text.trim(),
        'experience_years': int.tryParse(_expCtrl.text.trim()) ?? 0,
        'languages': _selectedLangs.toList(),
        'specializations': _selectedSpecs.toList(),
        if (_qualCtrl.text.trim().isNotEmpty) 'qualification': _qualCtrl.text.trim(),
        if (_bioCtrl.text.trim().isNotEmpty) 'bio': _bioCtrl.text.trim(),
      });
      if (!mounted) return;
      if (resp['statusCode'] == 200) {
        widget.onComplete();
      } else {
        _err(resp['detail']?.toString() ?? 'Could not save professional info');
      }
    } catch (e) {
      _err('Error: $e');
    }
    if (mounted) setState(() => _saving = false);
  }

  void _err(String msg) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: AppColors.error));
  }

  Widget _stepDot(int i, String label) {
    final active = _step >= i;
    return Expanded(child: Column(children: [
      CircleAvatar(radius: 14, backgroundColor: active ? AppColors.primary : AppColors.surface,
        child: Text('${i + 1}', style: TextStyle(color: active ? Colors.black : AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 13))),
      const SizedBox(height: 6),
      Text(label, style: TextStyle(color: active ? AppColors.primary : AppColors.textSecondary, fontSize: 11)),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.primary)));
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Complete your profile'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () => context.read<AuthBloc>().add(AuthLogoutRequested())),
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
            child: Row(children: [
              _stepDot(0, 'Personal'),
              _stepDot(1, 'Professional'),
              _stepDot(2, 'KYC'),
            ]),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [_personalStep(), _professionalStep()],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _card(List<Widget> children) => Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
      );

  Widget _personalStep() {
    return SingleChildScrollView(child: Form(key: _personalKey, child: _card([
      const Text('Personal Information', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 16)),
      const SizedBox(height: 4),
      const Text('Your mobile number is required to receive consultation requests.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      const SizedBox(height: 16),
      TextFormField(controller: _nameCtrl, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Full Name *', prefixIcon: Icon(Icons.person_outline, color: AppColors.textSecondary)), validator: (v) => (v == null || v.trim().length < 2) ? 'Required' : null),
      const SizedBox(height: 12),
      TextFormField(controller: _phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile Number *', prefixIcon: Icon(Icons.phone_outlined, color: AppColors.textSecondary)), validator: (v) => (v == null || v.trim().length < 6) ? 'Valid mobile number required' : null),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
        value: _gender,
        decoration: const InputDecoration(labelText: 'Gender', prefixIcon: Icon(Icons.wc, color: AppColors.textSecondary)),
        dropdownColor: AppColors.card,
        style: const TextStyle(color: AppColors.textPrimary),
        items: const [
          DropdownMenuItem(value: 'male', child: Text('Male')),
          DropdownMenuItem(value: 'female', child: Text('Female')),
          DropdownMenuItem(value: 'other', child: Text('Other')),
        ],
        onChanged: (v) => setState(() => _gender = v),
      ),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, child: ElevatedButton(
        onPressed: _saving ? null : _savePersonal,
        child: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)) : const Text('Next: Professional Info'),
      )),
    ])));
  }

  Widget _chipSelector(String label, List<String> options, Set<String> selected) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, children: options.map((opt) {
        final isSelected = selected.contains(opt);
        return FilterChip(
          label: Text(opt, style: TextStyle(color: isSelected ? Colors.black : AppColors.textSecondary, fontSize: 13)),
          selected: isSelected, selectedColor: AppColors.primary, backgroundColor: AppColors.surface,
          side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
          onSelected: (val) => setState(() => val ? selected.add(opt) : selected.remove(opt)),
        );
      }).toList()),
    ]);
  }

  Widget _professionalStep() {
    return SingleChildScrollView(child: Form(key: _professionalKey, child: _card([
      Row(children: [
        IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: const Icon(Icons.arrow_back, size: 20, color: AppColors.textSecondary), onPressed: () { setState(() => _step = 0); _pageController.animateToPage(0, duration: const Duration(milliseconds: 250), curve: Curves.easeOut); }),
        const SizedBox(width: 8),
        const Text('Professional Information', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 16)),
      ]),
      const SizedBox(height: 16),
      TextFormField(controller: _displayNameCtrl, decoration: const InputDecoration(labelText: 'Display Name', prefixIcon: Icon(Icons.badge_outlined, color: AppColors.textSecondary))),
      const SizedBox(height: 12),
      TextFormField(controller: _expCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Years of Experience', prefixIcon: Icon(Icons.calendar_today, color: AppColors.textSecondary))),
      const SizedBox(height: 12),
      TextFormField(controller: _qualCtrl, decoration: const InputDecoration(labelText: 'Qualification', prefixIcon: Icon(Icons.school_outlined, color: AppColors.textSecondary))),
      const SizedBox(height: 12),
      TextFormField(controller: _bioCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Short Bio', alignLabelWithHint: true)),
      const SizedBox(height: 16),
      _chipSelector('Languages *', _allLanguages, _selectedLangs),
      const SizedBox(height: 16),
      _chipSelector('Specializations *', _allSpecs, _selectedSpecs),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, child: ElevatedButton(
        onPressed: _saving ? null : _saveProfessional,
        child: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)) : const Text('Continue to KYC'),
      )),
    ])));
  }
}
