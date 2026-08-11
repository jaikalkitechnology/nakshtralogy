import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../bloc/chart/chart_bloc.dart';
import '../../bloc/chart/chart_event.dart';
import '../../bloc/chart/chart_state.dart';
import '../../services/api_service.dart';
import '../../widgets/recharge_sheet.dart';

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
    // The date picker's manual-entry (keyboard) field formats the date from
    // the active locale. US English is month-first (MM/DD/YYYY) while every
    // other language in this app is day-first (DD/MM/YYYY) — which is the
    // format we store. Force English to en_GB so it too shows DD/MM/YYYY,
    // keeping the picker's language unchanged; other locales stay as-is.
    final current = Localizations.localeOf(context);
    final pickerLocale =
        current.languageCode == 'en' ? const Locale('en', 'GB') : current;
    final picked = await showDatePicker(
      context: context, initialDate: DateTime(1990, 1, 1),
      firstDate: DateTime(1900), lastDate: DateTime.now(),
      locale: pickerLocale,
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

  /// Extra-chart paywall: the free Primary is used up, so this new chart needs a
  /// one-time `extra_chart` unlock (admin-priced). Buy the credit from the
  /// wallet (recharge if low), then re-submit — the backend consumes the credit.
  Future<void> _promptBuyExtraChart(BuildContext context, ChartPaymentRequired st) async {
    final l = AppLocalizations.of(context)!;
    final api = ApiService();
    final purchased = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        double balance = 0;
        bool loading = true;
        bool busy = false;
        return StatefulBuilder(builder: (ctx, setSheet) {
          if (loading) {
            api.getWalletBalance().then((b) { if (ctx.mounted) setSheet(() { balance = b; loading = false; }); });
          }
          final enough = balance >= st.price;
          return Container(
            decoration: const BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
            padding: EdgeInsets.fromLTRB(20, 14, 20, 20 + MediaQuery.of(ctx).viewInsets.bottom),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.smoke.withOpacity(0.4), borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Row(children: [
                Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.auto_awesome, color: AppColors.gold)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.newBirthChart, style: const TextStyle(color: AppColors.ivory, fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(l.pwOneTime, style: const TextStyle(color: AppColors.smoke, fontSize: 12)),
                ])),
              ]),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.nebula.withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(l.pwYourBalance, style: const TextStyle(color: AppColors.smoke, fontSize: 12)),
                  Text(loading ? '…' : '₹${balance.toStringAsFixed(0)}', style: TextStyle(color: enough ? AppColors.success : AppColors.error, fontSize: 14, fontWeight: FontWeight.w700)),
                ]),
              ),
              const SizedBox(height: 14),
              SizedBox(width: double.infinity, child: ElevatedButton(
                onPressed: (loading || busy) ? null : () async {
                  if (!enough) {
                    final ok = await showRechargeSheet(ctx, suggested: (st.price - balance).clamp(0, double.infinity).toDouble());
                    if (ok) {
                      final nb = await api.getWalletBalance();
                      if (ctx.mounted) setSheet(() => balance = nb);
                    }
                    return;
                  }
                  setSheet(() => busy = true);
                  final resp = await api.purchaseService(st.pricingId ?? '', '');
                  if (resp['statusCode'] == 200 || resp['statusCode'] == 201) {
                    if (ctx.mounted) Navigator.pop(ctx, true);
                  } else {
                    setSheet(() => busy = false);
                    if (ctx.mounted) ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(l.pwUnlockFailed), backgroundColor: AppColors.error));
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.midnight, minimumSize: const Size.fromHeight(48)),
                child: Text(busy ? l.pwProcessing : (enough ? l.pwUnlockPrice(st.price.toStringAsFixed(0)) : l.pwRechargeToUnlock), style: const TextStyle(fontWeight: FontWeight.w700)),
              )),
              const SizedBox(height: 6),
              Center(child: TextButton(onPressed: busy ? null : () => Navigator.pop(ctx, false), child: Text(l.pwMaybeLater, style: const TextStyle(color: AppColors.smoke)))),
            ]),
          );
        });
      },
    );
    if (purchased == true && mounted) _submit(); // retry — the credit now exists
  }

  Future<double?> _rechargeDialog(BuildContext context, double suggested) async {
    final l = AppLocalizations.of(context)!;
    final ctrl = TextEditingController(text: suggested > 0 ? suggested.ceil().toString() : '');
    return showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(l.pwAddMoney, style: const TextStyle(color: AppColors.ivory, fontSize: 16)),
        content: TextField(
          controller: ctrl, keyboardType: TextInputType.number, autofocus: true,
          style: const TextStyle(color: AppColors.ivory),
          decoration: InputDecoration(labelText: l.pwRechargeAmount),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.pwMaybeLater, style: const TextStyle(color: AppColors.smoke))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, double.tryParse(ctrl.text.trim())),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.midnight),
            child: Text(l.pwAddMoney),
          ),
        ],
      ),
    );
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
        if (state is ChartPaymentRequired) _promptBuyExtraChart(context, state);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory), onPressed: () => Navigator.pop(context)),
          title: Text(l.newBirthChart, maxLines: 1, overflow: TextOverflow.ellipsis),
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
                  Text(l.chartCategoryLabel, style: const TextStyle(color: AppColors.smoke, fontSize: 13)),
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
                  // The FIRST chart is your free Primary (free for all
                  // single-chart services). Once set it is fixed — later charts
                  // can't take over as primary, so the switch only shows for the
                  // very first chart.
                  BlocBuilder<ChartBloc, ChartState>(
                    builder: (context, state) {
                      final list = state is ChartLoaded ? state.charts : const [];
                      final hasPrimary = list.any((c) => (c is Map) && c['is_primary'] == true);
                      if (hasPrimary) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.nebula.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.gold.withOpacity(0.15)),
                          ),
                          child: Row(children: [
                            const Icon(Icons.info_outline, color: AppColors.smoke, size: 18),
                            const SizedBox(width: 10),
                            Expanded(child: Text(
                              l.firstChartPrimaryInfo,
                              maxLines: 3, overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: AppColors.smoke, fontSize: 11.5))),
                          ]),
                        );
                      }
                      return SwitchListTile(
                        title: Text(l.primary, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.ivory, fontSize: 13)),
                        subtitle: Text(l.freePrimaryDescription,
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
                        value: _isPrimary, onChanged: (v) => setState(() => _isPrimary = v),
                        activeColor: AppColors.gold, contentPadding: EdgeInsets.zero,
                      );
                    },
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
