import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../bloc/chart/chart_bloc.dart';
import '../../bloc/chart/chart_event.dart';
import '../../bloc/chart/chart_state.dart';
import '../../services/api_service.dart';
import '../../widgets/desktop_center.dart';

class AddClientChartScreen extends StatefulWidget {
  const AddClientChartScreen({super.key});
  @override
  State<AddClientChartScreen> createState() => _AddClientChartScreenState();
}

class _AddClientChartScreenState extends State<AddClientChartScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _tobCtrl = TextEditingController();
  final _placeCtrl = TextEditingController();
  String _gender = 'M';

  List<Map<String, dynamic>> _citySuggestions = [];
  bool _citySearching = false;
  Timer? _debounce;
  final _placeFocus = FocusNode();
  final _layerLink = LayerLink();
  OverlayEntry? _overlay;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: AppColors.primary)),
        child: child!,
      ),
    );
    if (picked != null) {
      _dobCtrl.text = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: AppColors.primary)),
        child: child!,
      ),
    );
    if (picked != null) {
      _tobCtrl.text = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    }
  }

  void _onPlaceChanged(String text) {
    _debounce?.cancel();
    if (text.length < 2) {
      _removeOverlay();
      return;
    }
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
          elevation: 8,
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 240),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _citySuggestions.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.border),
              itemBuilder: (_, i) {
                final c = _citySuggestions[i];
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.location_on, color: AppColors.primary, size: 18),
                  title: Text(c['name']?.toString() ?? '',
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: Text(c['display_name']?.toString() ?? '',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Text('${(c['latitude'] as num?)?.toStringAsFixed(2) ?? ''}, ${(c['longitude'] as num?)?.toStringAsFixed(2) ?? ''}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 9)),
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

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ChartBloc>().add(ChartCreateRequested(
      name: _nameCtrl.text.trim(),
      gender: _gender,
      dob: _dobCtrl.text.trim(),
      tob: _tobCtrl.text.trim(),
      place: _placeCtrl.text.trim(),
      serviceKey: 'birth_chart',
    ));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _removeOverlay();
    _nameCtrl.dispose();
    _dobCtrl.dispose();
    _tobCtrl.dispose();
    _placeCtrl.dispose();
    _placeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return BlocListener<ChartBloc, ChartState>(
      listener: (context, state) {
        if (state is ChartCreated) Navigator.pop(context);
        if (state is ChartFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
          title: Text(l.newClientChart),
        ),
        body: DesktopCenter(
          maxWidth: 640,
          child: GestureDetector(
          onTap: () { FocusScope.of(context).unfocus(); _removeOverlay(); },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
              child: Form(
                key: _formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.clientBirthDetails, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 20)),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(labelText: l.clientName, prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary)),
                    validator: (v) => (v == null || v.isEmpty) ? l.required : null,
                  ),
                  const SizedBox(height: 16),
                  Text(l.gender, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(children: ['M', 'F', 'O'].map((g) {
                    final labels = {'M': l.male, 'F': l.female, 'O': l.other};
                    final selected = _gender == g;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(labels[g]!, style: TextStyle(color: selected ? Colors.black : AppColors.textSecondary)),
                        selected: selected,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surface,
                        side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
                        onSelected: (_) => setState(() => _gender = g),
                      ),
                    );
                  }).toList()),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dobCtrl, readOnly: true, onTap: _pickDate,
                    decoration: InputDecoration(labelText: l.dateOfBirth, hintText: 'DD/MM/YYYY', prefixIcon: const Icon(Icons.calendar_today, color: AppColors.textSecondary)),
                    validator: (v) => (v == null || v.isEmpty) ? l.required : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _tobCtrl, readOnly: true, onTap: _pickTime,
                    decoration: InputDecoration(labelText: l.timeOfBirth, hintText: 'HH:MM', prefixIcon: const Icon(Icons.access_time, color: AppColors.textSecondary)),
                    validator: (v) => (v == null || v.isEmpty) ? l.required : null,
                  ),
                  const SizedBox(height: 16),
                  CompositedTransformTarget(
                    link: _layerLink,
                    child: TextFormField(
                      controller: _placeCtrl,
                      focusNode: _placeFocus,
                      onChanged: _onPlaceChanged,
                      decoration: InputDecoration(
                        labelText: l.birthPlace,
                        hintText: 'Type city name to search...',
                        prefixIcon: const Icon(Icons.place_outlined, color: AppColors.textSecondary),
                        suffixIcon: _citySearching
                            ? const Padding(padding: EdgeInsets.all(12), child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)))
                            : null,
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? l.required : null,
                    ),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<ChartBloc, ChartState>(builder: (context, state) {
                    final loading = state is ChartLoading;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loading ? null : _submit,
                        child: loading
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                            : Text(l.generateKundli),
                      ),
                    );
                  }),
                ]),
              ),
            ),
          ),
        )),
      ),
    );
  }
}
