import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_theme.dart';
import '../../bloc/chart/chart_bloc.dart';
import '../../bloc/chart/chart_event.dart';
import '../../bloc/chart/chart_state.dart';

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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ChartBloc>().add(ChartCreateRequested(
      name: _nameCtrl.text.trim(), gender: _gender,
      dob: _dobCtrl.text.trim(), tob: _tobCtrl.text.trim(),
      place: _placeCtrl.text.trim(), isPrimary: _isPrimary,
      serviceKey: 'birth_chart',
    ));
  }

  @override
  void dispose() { _nameCtrl.dispose(); _dobCtrl.dispose(); _tobCtrl.dispose(); _placeCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChartBloc, ChartState>(
      listener: (context, state) {
        if (state is ChartCreated) Navigator.pop(context);
        if (state is ChartFailure) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
          title: const Text('New Birth Chart'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
            child: Form(
              key: _formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('\U0001f4dc', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 8),
                Text('Birth Details', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 20)),
                const SizedBox(height: 24),
                TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline, color: AppColors.textSecondary)), validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
                const SizedBox(height: 16),
                Text('Gender', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                const SizedBox(height: 8),
                Row(children: ['M', 'F', 'O'].map((g) {
                  final labels = {'M': 'Male', 'F': 'Female', 'O': 'Other'};
                  final selected = _gender == g;
                  return Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(
                    label: Text(labels[g]!, style: TextStyle(color: selected ? Colors.black : AppColors.textSecondary)),
                    selected: selected, selectedColor: AppColors.primary, backgroundColor: AppColors.surface,
                    side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
                    onSelected: (_) => setState(() => _gender = g),
                  ));
                }).toList()),
                const SizedBox(height: 16),
                TextFormField(controller: _dobCtrl, readOnly: true, onTap: _pickDate, decoration: const InputDecoration(labelText: 'Date of Birth', hintText: 'DD/MM/YYYY', prefixIcon: Icon(Icons.calendar_today, color: AppColors.textSecondary)), validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
                const SizedBox(height: 16),
                TextFormField(controller: _tobCtrl, readOnly: true, onTap: _pickTime, decoration: const InputDecoration(labelText: 'Time of Birth', hintText: 'HH:MM', prefixIcon: Icon(Icons.access_time, color: AppColors.textSecondary)), validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
                const SizedBox(height: 16),
                TextFormField(controller: _placeCtrl, decoration: const InputDecoration(labelText: 'Birth Place', hintText: 'e.g. Delhi, Mumbai', prefixIcon: Icon(Icons.place_outlined, color: AppColors.textSecondary)), validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
                const SizedBox(height: 16),
                SwitchListTile(title: const Text('Set as primary chart', style: TextStyle(color: AppColors.textPrimary, fontSize: 14)), subtitle: const Text('Used for daily horoscope', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)), value: _isPrimary, onChanged: (v) => setState(() => _isPrimary = v), activeColor: AppColors.primary, contentPadding: EdgeInsets.zero),
                const SizedBox(height: 24),
                BlocBuilder<ChartBloc, ChartState>(
                  builder: (context, state) {
                    final loading = state is ChartLoading;
                    return ElevatedButton(
                      onPressed: loading ? null : _submit,
                      child: loading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)) : const Text('Generate Kundli'),
                    );
                  },
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
