import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

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
  bool _loading = false;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 1, 1),
      firstDate: DateTime(1900),
      lastDate: now,
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final result = await ApiService().createChart(
      name: _nameCtrl.text.trim(),
      gender: _gender,
      dob: _dobCtrl.text.trim(),
      tob: _tobCtrl.text.trim(),
      place: _placeCtrl.text.trim(),
      serviceKey: 'birth_chart',
    );

    setState(() => _loading = false);

    if (!mounted) return;
    if (result['statusCode'] == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Client chart created!'), backgroundColor: AppColors.success),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['detail'] ?? 'Failed'), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dobCtrl.dispose();
    _tobCtrl.dispose();
    _placeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('New Client Chart'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Client Birth Details', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 20)),
                const SizedBox(height: 4),
                Text('Generate Janam Kundli for your client', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Client Name', prefixIcon: Icon(Icons.person_outline, color: AppColors.textSecondary)),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                Text('Gender', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  children: ['M', 'F', 'O'].map((g) {
                    final labels = {'M': 'Male', 'F': 'Female', 'O': 'Other'};
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
                  }).toList(),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _dobCtrl,
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: const InputDecoration(labelText: 'Date of Birth', hintText: 'DD/MM/YYYY', prefixIcon: Icon(Icons.calendar_today, color: AppColors.textSecondary)),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _tobCtrl,
                  readOnly: true,
                  onTap: _pickTime,
                  decoration: const InputDecoration(labelText: 'Time of Birth', hintText: 'HH:MM', prefixIcon: Icon(Icons.access_time, color: AppColors.textSecondary)),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _placeCtrl,
                  decoration: const InputDecoration(labelText: 'Birth Place', hintText: 'e.g. Delhi, Mumbai', prefixIcon: Icon(Icons.place_outlined, color: AppColors.textSecondary)),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                      : const Text('Generate Kundli'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
