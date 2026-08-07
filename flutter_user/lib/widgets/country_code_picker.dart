import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A single dialing country. `iso` is the ISO-3166 alpha-2 code the backend
/// uses to seed the region (IN vs INTL); `dial` is the calling code shown to
/// the user; `flag` is the emoji rendered in the picker.
class Country {
  final String name;
  final String iso;
  final String dial; // without the leading '+'
  final String flag;
  const Country(this.name, this.iso, this.dial, this.flag);

  String get display => '$flag +$dial';
}

/// Curated dialing-country list. India is first so it is the natural default.
/// This is intentionally self-contained (no extra package) — it covers the
/// markets Nakshatralogy serves plus the major international ones.
const List<Country> kCountries = [
  Country('India', 'IN', '91', '🇮🇳'),
  Country('United States', 'US', '1', '🇺🇸'),
  Country('United Kingdom', 'GB', '44', '🇬🇧'),
  Country('United Arab Emirates', 'AE', '971', '🇦🇪'),
  Country('Canada', 'CA', '1', '🇨🇦'),
  Country('Australia', 'AU', '61', '🇦🇺'),
  Country('Singapore', 'SG', '65', '🇸🇬'),
  Country('Malaysia', 'MY', '60', '🇲🇾'),
  Country('Saudi Arabia', 'SA', '966', '🇸🇦'),
  Country('Qatar', 'QA', '974', '🇶🇦'),
  Country('Kuwait', 'KW', '965', '🇰🇼'),
  Country('Bahrain', 'BH', '973', '🇧🇭'),
  Country('Oman', 'OM', '968', '🇴🇲'),
  Country('Nepal', 'NP', '977', '🇳🇵'),
  Country('Sri Lanka', 'LK', '94', '🇱🇰'),
  Country('Bangladesh', 'BD', '880', '🇧🇩'),
  Country('Pakistan', 'PK', '92', '🇵🇰'),
  Country('New Zealand', 'NZ', '64', '🇳🇿'),
  Country('South Africa', 'ZA', '27', '🇿🇦'),
  Country('Germany', 'DE', '49', '🇩🇪'),
  Country('France', 'FR', '33', '🇫🇷'),
  Country('Italy', 'IT', '39', '🇮🇹'),
  Country('Spain', 'ES', '34', '🇪🇸'),
  Country('Portugal', 'PT', '351', '🇵🇹'),
  Country('Netherlands', 'NL', '31', '🇳🇱'),
  Country('Switzerland', 'CH', '41', '🇨🇭'),
  Country('Sweden', 'SE', '46', '🇸🇪'),
  Country('Ireland', 'IE', '353', '🇮🇪'),
  Country('Russia', 'RU', '7', '🇷🇺'),
  Country('Turkey', 'TR', '90', '🇹🇷'),
  Country('Israel', 'IL', '972', '🇮🇱'),
  Country('China', 'CN', '86', '🇨🇳'),
  Country('Japan', 'JP', '81', '🇯🇵'),
  Country('South Korea', 'KR', '82', '🇰🇷'),
  Country('Hong Kong', 'HK', '852', '🇭🇰'),
  Country('Thailand', 'TH', '66', '🇹🇭'),
  Country('Indonesia', 'ID', '62', '🇮🇩'),
  Country('Philippines', 'PH', '63', '🇵🇭'),
  Country('Vietnam', 'VN', '84', '🇻🇳'),
  Country('Brazil', 'BR', '55', '🇧🇷'),
  Country('Mexico', 'MX', '52', '🇲🇽'),
  Country('Nigeria', 'NG', '234', '🇳🇬'),
  Country('Kenya', 'KE', '254', '🇰🇪'),
  Country('Egypt', 'EG', '20', '🇪🇬'),
];

const Country kDefaultCountry = kCountries[0]; // India

Country countryForIso(String? iso) {
  if (iso == null) return kDefaultCountry;
  final up = iso.trim().toUpperCase();
  return kCountries.firstWhere((c) => c.iso == up, orElse: () => kDefaultCountry);
}

/// Compact tappable prefix that opens a searchable country sheet. Meant to sit
/// as the `prefixIcon` of a phone `TextField`.
class CountryCodePicker extends StatelessWidget {
  final Country value;
  final ValueChanged<Country> onSelected;
  const CountryCodePicker({super.key, required this.value, required this.onSelected});

  Future<void> _open(BuildContext context) async {
    final picked = await showModalBottomSheet<Country>(
      context: context,
      backgroundColor: AppColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _CountrySheet(),
    );
    if (picked != null) onSelected(picked);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _open(context),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(value.flag, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 4),
          Text('+${value.dial}',
              style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
          const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary, size: 20),
        ]),
      ),
    );
  }
}

class _CountrySheet extends StatefulWidget {
  const _CountrySheet();
  @override
  State<_CountrySheet> createState() => _CountrySheetState();
}

class _CountrySheetState extends State<_CountrySheet> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final q = _q.trim().toLowerCase();
    final list = q.isEmpty
        ? kCountries
        : kCountries
            .where((c) =>
                c.name.toLowerCase().contains(q) ||
                c.dial.contains(q) ||
                c.iso.toLowerCase().contains(q))
            .toList();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              autofocus: false,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Search country or code',
                prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
              ),
              onChanged: (v) => setState(() => _q = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, i) {
                final c = list[i];
                return ListTile(
                  leading: Text(c.flag, style: const TextStyle(fontSize: 22)),
                  title: Text(c.name, style: const TextStyle(color: AppColors.textPrimary)),
                  trailing: Text('+${c.dial}', style: const TextStyle(color: AppColors.textSecondary)),
                  onTap: () => Navigator.pop(context, c),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
