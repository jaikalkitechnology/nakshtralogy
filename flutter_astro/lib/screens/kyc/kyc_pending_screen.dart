import '../../l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/kyc/kyc_bloc.dart';
import '../../bloc/kyc/kyc_event.dart';
import '../../bloc/kyc/kyc_state.dart';

/// Shown when KYC has been submitted and is awaiting admin review.
class KycPendingScreen extends StatelessWidget {
  const KycPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.kycPending ?? 'KYC Under Review'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
          ),
        ],
      ),
      body: BlocBuilder<KycBloc, KycState>(
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                      ),
                      child: const Icon(Icons.hourglass_top, color: AppColors.primary, size: 36),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'KYC Under Review',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Hi Astrologer 🙏',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Your KYC documents are awaiting admin approval. This usually takes 24–48 hours. You will receive a push notification once approved and can start accepting consultations.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 11, height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    if (state.docType != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            _row('Document type', state.docType!),
                            if (state.docNumber != null) _row('Number', state.docNumber!),
                            if (state.submittedAt != null)
                              _row('Submitted', state.submittedAt!.substring(0, 16)),
                            _row('Status', 'Pending'),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => context.read<KycBloc>().add(KycStatusRequested()),
                            icon: const Icon(Icons.refresh, size: 16),
                            label: Text(AppLocalizations.of(context)?.refresh ?? 'Refresh'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
                            icon: const Icon(Icons.logout, size: 16, color: AppColors.error),
                            label: const Text('Logout', style: TextStyle(color: AppColors.error)),
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.error)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
          ),
          Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 10)),
        ],
      ),
    );
  }
}
