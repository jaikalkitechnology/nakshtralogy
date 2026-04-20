import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../bloc/chart/chart_bloc.dart';
import '../../bloc/chart/chart_event.dart';
import '../../bloc/chart/chart_state.dart';
import '../../services/api_service.dart';

class AddChartScreen extends StatefulWidget {
  const AddChartScreen({super.key});

  @override
  State<AddChartScreen> createState() => _AddChartScreenState();
}

class _AddChartScreenState extends State<AddChartScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _tobCtrl = TextEditingController();
  final _placeCtrl = TextEditingController();
  String _gender = 'M';
  bool _isPrimary = false;
  String _category = 'self';

  List<Map<String, dynamic>> _citySuggestions = [];
  bool _citySearching = false;
  Timer? _debounce;
  final _layerLink = LayerLink();
  OverlayEntry? _overlay;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context, initialDate: DateTime(1990, 1, 1),
      firstDate: DateTime(1900), lastDate: DateTime.now(),
      builder: (context, child) => Theme(data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: AppColors.primary)), child: child!),
    );
    if (picked != null) _dobCtrl.text = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context, initialTime: const TimeOfDay(hour: 12, minute: 0),
      builder: (context, child) => Theme(data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: AppColors.primary)), child: child!),
    );
    if (picked != null) _tobCtrl.text = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
  }

  void _onPlaceChanged(String text) {
    _debounce?.cancel();
    if (text.length < 2) { _removeOverlay(); return; }
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      setState(() => _citySearching = true);
      try {
        final results = await ApiService().searchCities(text);
        if (!mounted) return;
        _citySuggestions = results.map((e) => (e as Map).cast<String, dynamic>()).toList();
        _showOverlay();
      } catch (_) {}
      if (mounted) setState(() => _citySearching = false);
    });
  }

  void _selectCity(Map<String, dynamic> city) {
    _placeCtrl.text = city['display_name']?.toString() ?? city['name']?.toString() ?? '';
    _removeOverlay();
  }

  void _showOverlay() {
    _removeOverlay();
    if (_citySuggestions.isEmpty) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    _overlay = OverlayEntry(builder: (ctx) => Positioned(
      width: renderBox.size.width - 48,
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: const Offset(0, 56),
        child: Material(
          elevation: 8, color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 240),
            child: ListView.separated(
              shrinkWrap: true, padding: EdgeInsets.zero,
              itemCount: _citySuggestions.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.gold.withOpacity(0.1)),
              itemBuilder: (_, i) {
                final c = _citySuggestions[i];
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.location_on, color: AppColors.gold, size: 18),
                  title: Text(c['name']?.toString() ?? '', style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: Text(c['display_name']?.toString() ?? '', style: const TextStyle(color: AppColors.smoke, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Text('${(c['latitude'] as num?)?.toStringAsFixed(2) ?? ''}, ${(c['longitude'] as num?)?.toStringAsFixed(2) ?? ''}',
                      style: const TextStyle(color: AppColors.smoke, fontSize: 9)),
                  onTap: () => _selectCity(c),
                );
              },
            ),
          ),
        ),
      ),
    ));
    Overlay.of(context).insert(_overlay!);
  }

  void _removeOverlay() { _overlay?.remove(); _overlay = null; }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ChartBloc>().add(ChartCreateRequested(
      name: _nameCtrl.text.trim(), gender: _gender,
      dob: _dobCtrl.text.trim(), tob: _tobCtrl.text.trim(),
      place: _placeCtrl.text.trim(), isPrimary: _isPrimary,
      serviceKey: 'birth_chart', category: _category,
    ));
  }

  @override
  void dispose() {
    _debounce?.cancel(); _removeOverlay();
    _nameCtrl.dispose(); _dobCtrl.dispose(); _tobCtrl.dispose(); _placeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return BlocListener<ChartBloc, ChartState>(
      listener: (context, state) {
        if (state is ChartCreated) Navigator.pop(context);
        if (state is ChartFailure) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory), onPressed: () => Navigator.pop(context)),
          title: Text(l.newBirthChart),
        ),
        body: GestureDetector(
          onTap: () { FocusScope.of(context).unfocus(); _removeOverlay(); },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.gold.withOpacity(0.15)),
              ),
              child: Form(
                key: _formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.birthDetails, style: const TextStyle(color: AppColors.gold, fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(labelText: l.fullName, prefixIcon: const Icon(Icons.person_outline, color: AppColors.smoke)),
                    validator: (v) => (v == null || v.isEmpty) ? l.required : null,
                  ),
                  const SizedBox(height: 14),
                  Text(l.gender, style: const TextStyle(color: AppColors.smoke, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(children: ['M', 'F', 'O'].map((g) {
                    final labels = {'M': l.male, 'F': l.female, 'O': l.other};
                    final selected = _gender == g;
                    return Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(
                      label: Text(labels[g]!, style: TextStyle(color: selected ? AppColors.midnight : AppColors.smoke, fontSize: 13)),
                      selected: selected, selectedColor: AppColors.gold, backgroundColor: AppColors.nebula,
                      side: BorderSide(color: selected ? AppColors.gold : AppColors.ash),
                      onSelected: (_) => setState(() => _gender = g),
                    ));
                  }).toList()),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _dobCtrl, readOnly: true, onTap: _pickDate,
                    decoration: InputDecoration(labelText: l.dateOfBirth, hintText: 'DD/MM/YYYY', prefixIcon: const Icon(Icons.calendar_today, color: AppColors.smoke)),
                    validator: (v) => (v == null || v.isEmpty) ? l.required : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _tobCtrl, readOnly: true, onTap: _pickTime,
                    decoration: InputDecoration(labelText: l.timeOfBirth, hintText: 'HH:MM', prefixIcon: const Icon(Icons.access_time, color: AppColors.smoke)),
                    validator: (v) => (v == null || v.isEmpty) ? l.required : null,
                  ),
                  const SizedBox(height: 14),
                  CompositedTransformTarget(
                    link: _layerLink,
                    child: TextFormField(
                      controller: _placeCtrl,
                      onChanged: _onPlaceChanged,
                      decoration: InputDecoration(
                        labelText: l.birthPlace,
                        hintText: l.birthPlaceHint,
                        prefixIcon: const Icon(Icons.place_outlined, color: AppColors.smoke),
                        suffixIcon: _citySearching
                            ? const Padding(padding: EdgeInsets.all(12), child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold)))
                            : null,
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? l.required : null,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text('Category', style: const TextStyle(color: AppColors.smoke, fontSize: 13)),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, children: ['self', 'family', 'friend', 'other'].map((c) {
                    final labels = {'self': '\u{1F464} Self', 'family': '\u{1F46A} Family', 'friend': '\u{1F91D} Friend', 'other': '\u{2728} Other'};
                    final sel = _category == c;
                    return ChoiceChip(
                      label: Text(labels[c]!, style: TextStyle(color: sel ? AppColors.midnight : AppColors.smoke, fontSize: 12)),
                      selected: sel, selectedColor: AppColors.gold, backgroundColor: AppColors.nebula,
                      side: BorderSide(color: sel ? AppColors.gold : AppColors.ash),
                      onSelected: (_) => setState(() => _category = c),
                    );
                  }).toList()),
                  const SizedBox(height: 14),
                  SwitchListTile(
                    title: Text(l.primary, style: const TextStyle(color: AppColors.ivory, fontSize: 13)),
                    subtitle: const Text('Used for daily horoscope', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
                    value: _isPrimary, onChanged: (v) => setState(() => _isPrimary = v),
                    activeColor: AppColors.gold, contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<ChartBloc, ChartState>(
                    builder: (context, state) {
                      final loading = state is ChartLoading;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: loading ? null : _submit,
                          child: loading
                              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.midnight))
                              : Text(l.generateKundli),
                        ),
                      );
                    },
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
