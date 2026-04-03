import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
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
      isPrimary: _isPrimary,
      serviceKey: 'birth_chart',
    );

    setState(() => _loading = false);

    if (!mounted) return;
    if (result['statusCode'] == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Birth chart created successfully!'), backgroundColor: AppColors.success),
      );
      Navigator.pop(context, true); // signal refresh
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['detail'] ?? 'Failed to create chart'), backgroundColor: AppColors.error),
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
        title: const Text('New Birth Chart'),
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
                const Text('📜', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 8),
                Text('Birth Details', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 20)),
                const SizedBox(height: 4),
                Text('Enter birth data to generate Janam Kundli', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 24),

                // Name
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline, color: AppColors.textSecondary),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),

                // Gender
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

                // DOB
                TextFormField(
                  controller: _dobCtrl,
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    hintText: 'DD/MM/YYYY',
                    prefixIcon: Icon(Icons.calendar_today, color: AppColors.textSecondary),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'DOB is required' : null,
                ),
                const SizedBox(height: 16),

                // TOB
                TextFormField(
                  controller: _tobCtrl,
                  readOnly: true,
                  onTap: _pickTime,
                  decoration: const InputDecoration(
                    labelText: 'Time of Birth',
                    hintText: 'HH:MM',
                    prefixIcon: Icon(Icons.access_time, color: AppColors.textSecondary),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Time is required' : null,
                ),
                const SizedBox(height: 16),

                // Place
                TextFormField(
                  controller: _placeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Birth Place',
                    hintText: 'e.g. Delhi, Mumbai, Varanasi',
                    prefixIcon: Icon(Icons.place_outlined, color: AppColors.textSecondary),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Place is required' : null,
                ),
                const SizedBox(height: 16),

                // Primary toggle
                SwitchListTile(
                  title: const Text('Set as my primary chart', style: TextStyle(color: AppColors.textPrimary, fontSize: 14)),
                  subtitle: const Text('Used for daily horoscope', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  value: _isPrimary,
                  onChanged: (v) => setState(() => _isPrimary = v),
                  activeColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 24),

                // Submit
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
