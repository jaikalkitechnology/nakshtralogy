import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../utils/menu_labels.dart';

/// Legal / policy links shown in Profile → "About & Legal".
/// All three pages live on nakshatralogy.com and open in the external browser.
class LegalSection extends StatelessWidget {
  const LegalSection({super.key});

  static const String privacyUrl = 'https://nakshatralogy.com/privacy-policy.html';
  static const String termsUrl = 'https://nakshatralogy.com/terms.html';
  static const String refundUrl = 'https://nakshatralogy.com/refund-policy.html';

  Future<void> _open(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(MenuLabels.of(context, 'couldNotOpen'))),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(MenuLabels.of(context, 'couldNotOpen'))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(MenuLabels.of(context, 'aboutLegal'),
            style: const TextStyle(color: AppColors.smoke, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
      ),
      _tile(context, Icons.privacy_tip_outlined, MenuLabels.of(context, 'privacyPolicy'), privacyUrl),
      _tile(context, Icons.description_outlined, MenuLabels.of(context, 'termsConditions'), termsUrl),
      _tile(context, Icons.receipt_long_outlined, MenuLabels.of(context, 'refundPolicy'), refundUrl),
    ]);
  }

  Widget _tile(BuildContext context, IconData icon, String title, String url) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _open(context, url),
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.gold.withOpacity(0.15)),
        ),
        child: Row(children: [
          Icon(icon, color: AppColors.gold, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w600))),
          const Icon(Icons.open_in_new, color: AppColors.gold, size: 18),
        ]),
      ),
    );
  }
}
