import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// One entry in the curated country list: ISO 3166-1 alpha-2 code, English
/// name and E.164 dial code. The flag emoji is DERIVED from [iso] (regional
/// indicator math) so no asset or extra package is needed.
class CountryCode {
  const CountryCode({required this.iso, required this.name, required this.dialCode});

  /// ISO 3166-1 alpha-2, uppercase (e.g. `'IN'`).
  final String iso;

  /// English display name (e.g. `'India'`).
  final String name;

  /// Dial code with leading `+` (e.g. `'+91'`) — matches the backend's
  /// `country_code` format (`^\+\d{1,4}$`).
  final String dialCode;

  /// Emoji flag built from [iso]: each A–Z letter maps to its regional
  /// indicator symbol (U+1F1E6 + offset), and the two-symbol pair renders as
  /// the country's flag on every modern platform.
  String get flag => String.fromCharCodes(
        iso.toUpperCase().codeUnits.map((c) => 0x1F1E6 + (c - 0x41)),
      );
}

/// Curated list of common countries — India FIRST (the primary market), the
/// rest alphabetical by English name. Two entries may share a dial code
/// (e.g. Canada/US on +1); lookups by dial code return the first match.
const List<CountryCode> kCountryCodes = [
  CountryCode(iso: 'IN', name: 'India', dialCode: '+91'),
  CountryCode(iso: 'AU', name: 'Australia', dialCode: '+61'),
  CountryCode(iso: 'BH', name: 'Bahrain', dialCode: '+973'),
  CountryCode(iso: 'BD', name: 'Bangladesh', dialCode: '+880'),
  CountryCode(iso: 'BR', name: 'Brazil', dialCode: '+55'),
  CountryCode(iso: 'CA', name: 'Canada', dialCode: '+1'),
  CountryCode(iso: 'CN', name: 'China', dialCode: '+86'),
  CountryCode(iso: 'EG', name: 'Egypt', dialCode: '+20'),
  CountryCode(iso: 'FR', name: 'France', dialCode: '+33'),
  CountryCode(iso: 'DE', name: 'Germany', dialCode: '+49'),
  CountryCode(iso: 'HK', name: 'Hong Kong', dialCode: '+852'),
  CountryCode(iso: 'ID', name: 'Indonesia', dialCode: '+62'),
  CountryCode(iso: 'IE', name: 'Ireland', dialCode: '+353'),
  CountryCode(iso: 'IL', name: 'Israel', dialCode: '+972'),
  CountryCode(iso: 'IT', name: 'Italy', dialCode: '+39'),
  CountryCode(iso: 'JP', name: 'Japan', dialCode: '+81'),
  CountryCode(iso: 'KE', name: 'Kenya', dialCode: '+254'),
  CountryCode(iso: 'KW', name: 'Kuwait', dialCode: '+965'),
  CountryCode(iso: 'MY', name: 'Malaysia', dialCode: '+60'),
  CountryCode(iso: 'MV', name: 'Maldives', dialCode: '+960'),
  CountryCode(iso: 'MU', name: 'Mauritius', dialCode: '+230'),
  CountryCode(iso: 'NP', name: 'Nepal', dialCode: '+977'),
  CountryCode(iso: 'NL', name: 'Netherlands', dialCode: '+31'),
  CountryCode(iso: 'NZ', name: 'New Zealand', dialCode: '+64'),
  CountryCode(iso: 'NG', name: 'Nigeria', dialCode: '+234'),
  CountryCode(iso: 'OM', name: 'Oman', dialCode: '+968'),
  CountryCode(iso: 'PK', name: 'Pakistan', dialCode: '+92'),
  CountryCode(iso: 'PH', name: 'Philippines', dialCode: '+63'),
  CountryCode(iso: 'PL', name: 'Poland', dialCode: '+48'),
  CountryCode(iso: 'QA', name: 'Qatar', dialCode: '+974'),
  CountryCode(iso: 'RU', name: 'Russia', dialCode: '+7'),
  CountryCode(iso: 'SA', name: 'Saudi Arabia', dialCode: '+966'),
  CountryCode(iso: 'SG', name: 'Singapore', dialCode: '+65'),
  CountryCode(iso: 'ZA', name: 'South Africa', dialCode: '+27'),
  CountryCode(iso: 'KR', name: 'South Korea', dialCode: '+82'),
  CountryCode(iso: 'ES', name: 'Spain', dialCode: '+34'),
  CountryCode(iso: 'LK', name: 'Sri Lanka', dialCode: '+94'),
  CountryCode(iso: 'SE', name: 'Sweden', dialCode: '+46'),
  CountryCode(iso: 'CH', name: 'Switzerland', dialCode: '+41'),
  CountryCode(iso: 'TH', name: 'Thailand', dialCode: '+66'),
  CountryCode(iso: 'TR', name: 'Turkey', dialCode: '+90'),
  CountryCode(iso: 'AE', name: 'United Arab Emirates', dialCode: '+971'),
  CountryCode(iso: 'GB', name: 'United Kingdom', dialCode: '+44'),
  CountryCode(iso: 'US', name: 'United States', dialCode: '+1'),
];

/// First list entry matching [dialCode]; falls back to India when the code is
/// unknown (defensive — a backend value outside the curated list shouldn't
/// crash the picker, and +91 is the sensible default for this product).
CountryCode countryForDialCode(String? dialCode) => kCountryCodes.firstWhere(
      (c) => c.dialCode == dialCode,
      orElse: () => kCountryCodes.first,
    );

/// Compact country-code selector ("🇮🇳 +91") that opens a bottom sheet of
/// [kCountryCodes] (flag + name + dial code). Purely presentational: the
/// caller owns the selected dial code and receives changes via [onChanged].
/// Sized/styled to sit inline next to a phone-number `TextField`.
class CountryCodePicker extends StatelessWidget {
  const CountryCodePicker({
    super.key,
    required this.dialCode,
    required this.onChanged,
    this.enabled = true,
  });

  /// Currently selected dial code (e.g. `'+91'`).
  final String dialCode;

  /// Called with the tapped entry when the astrologer/user picks a country.
  final ValueChanged<CountryCode> onChanged;

  final bool enabled;

  Future<void> _open(BuildContext context) async {
    final selected = await showModalBottomSheet<CountryCode>(
      context: context,
      backgroundColor: AppColors.indigoDeep,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Country code', style: AppTextStyles.heading(size: 16)),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: kCountryCodes.length,
                itemBuilder: (context, i) {
                  final c = kCountryCodes[i];
                  final active = c.dialCode == dialCode;
                  return ListTile(
                    dense: true,
                    leading: Text(c.flag, style: const TextStyle(fontSize: 22)),
                    title: Text(c.name, style: AppTextStyles.body(size: 14)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          c.dialCode,
                          style: AppTextStyles.mono(
                            size: 13,
                            color: active ? AppColors.saffronBright : AppColors.ivoryDim,
                          ),
                        ),
                        if (active) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.check, size: 18, color: AppColors.saffron),
                        ],
                      ],
                    ),
                    onTap: () => Navigator.pop(context, c),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (selected != null) onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    final country = countryForDialCode(dialCode);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: enabled ? () => _open(context) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(country.flag, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Text(country.dialCode, style: AppTextStyles.body(size: 14)),
            const SizedBox(width: 2),
            Icon(Icons.arrow_drop_down, size: 20, color: AppColors.ivoryDim),
          ],
        ),
      ),
    );
  }
}
