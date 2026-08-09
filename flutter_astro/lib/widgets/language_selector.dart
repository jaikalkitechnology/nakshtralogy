import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../main.dart';
import '../l10n/gen/app_localizations.dart';

class LanguageSelector {
  static const languages = [
    {'code': 'en', 'name': 'English',   'native': 'English'},
    {'code': 'hi', 'name': 'Hindi',     'native': 'हिन्दी'},
    {'code': 'hi_Latn', 'name': 'Hinglish', 'native': 'Hinglish'},
    {'code': 'mr', 'name': 'Marathi',   'native': 'मराठी'},
    {'code': 'gu', 'name': 'Gujarati',  'native': 'ગુજરાતી'},
    {'code': 'ta', 'name': 'Tamil',     'native': 'தமிழ்'},
    {'code': 'te', 'name': 'Telugu',    'native': 'తెలుగు'},
    {'code': 'kn', 'name': 'Kannada',   'native': 'ಕನ್ನಡ'},
    {'code': 'bn', 'name': 'Bengali',   'native': 'বাংলা'},
    {'code': 'pa', 'name': 'Punjabi',   'native': 'ਪੰਜਾਬੀ'},
    {'code': 'ml', 'name': 'Malayalam', 'native': 'മലയാളം'},
  ];

  static void show(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    // Resolve to a code that EXISTS in the options — iOS Safari attaches
    // scriptCode:'Latn' to Latin locales, so a naive '<lang>_<script>' wouldn't
    // match and the current language wouldn't be ticked.
    final codes = languages.map((m) => m['code']).toSet();
    final lang = locale.languageCode;
    final sc = locale.scriptCode;
    final cc = locale.countryCode;
    final currentLocale = (sc != null && codes.contains('${lang}_$sc'))
        ? '${lang}_$sc'
        : (cc != null && codes.contains('${lang}_$cc'))
            ? '${lang}_$cc'
            : lang;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.nebula,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.smoke, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Text(l.selectLanguage, style: const TextStyle(color: AppColors.gold, fontSize: 18, fontWeight: FontWeight.w700)),
          const Text('भाषा चुनें', style: TextStyle(color: AppColors.smoke, fontSize: 12)),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: languages.length,
              itemBuilder: (_, i) {
                final lang = languages[i];
                final isSelected = lang['code'] == currentLocale;
                return ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: isSelected ? AppColors.gold.withOpacity(0.15) : Colors.transparent,
                  leading: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.gold.withOpacity(0.2) : AppColors.twilight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isSelected ? AppColors.gold : AppColors.ash),
                    ),
                    child: Center(child: Text(lang['code']!.toUpperCase(),
                        style: TextStyle(color: isSelected ? AppColors.gold : AppColors.smoke, fontSize: 11, fontWeight: FontWeight.w700))),
                  ),
                  title: Text(lang['native']!, style: TextStyle(color: isSelected ? AppColors.gold : AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w600)),
                  subtitle: Text(lang['name']!, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
                  trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.gold, size: 22) : null,
                  onTap: () {
                    final code = lang['code']!;
                    final parts = code.split('_');
                    final newLocale = parts.length > 1
                        ? Locale.fromSubtags(languageCode: parts[0], scriptCode: parts[1])
                        : Locale(code);
                    NakshatralogyAstroApp.setLocale(context, newLocale);
                    Navigator.pop(ctx);
                  },
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
