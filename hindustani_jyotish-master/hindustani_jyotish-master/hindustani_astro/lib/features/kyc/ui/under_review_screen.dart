import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import '../../../shared/widgets/cosmic_background.dart';
import '../../auth/astro_session_cubit.dart';

/// Holding screen shown while KYC is pending (or after rejection).
class UnderReviewScreen extends StatelessWidget {
  const UnderReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final astro = context.select((AstroSessionCubit c) => c.state.astrologer);
    final rejected = astro?.kycStatus == 'rejected';
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          // Pull-to-refresh re-fetches the session (`/astrologer/me`) — the
          // same reload path as the "Refresh status" button below. The content
          // fits on screen, so an always-scrollable SingleChildScrollView (with
          // the column re-centered via a min-height box) keeps the gesture
          // working anyway.
          child: RefreshIndicator(
            onRefresh: () => context.read<AstroSessionCubit>().refresh(),
            color: AppColors.saffron,
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(rejected ? Icons.cancel_outlined : Icons.hourglass_top,
                    size: 64, color: rejected ? AppColors.danger : AppColors.gold),
                const SizedBox(height: 20),
                Text(rejected ? 'Application rejected' : 'Application under review',
                    textAlign: TextAlign.center, style: AppTextStyles.display(size: 24)),
                const SizedBox(height: 12),
                Text(
                  rejected
                      ? 'Your KYC was not approved. Please review your details and resubmit.'
                      : 'Our team is verifying your details. You will be notified once approved.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body(color: AppColors.ivoryDim),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
      // Explicit full width: the shared theme no longer forces an
      // (invalid) infinite minimum width on every ElevatedButton.
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  onPressed: () => context.go('/kyc'),
                  child: Text(rejected ? 'Resubmit KYC' : 'Fill / update KYC details'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => context.read<AstroSessionCubit>().refresh(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.borderMid),
                    foregroundColor: AppColors.ivory,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Refresh status'),
                ),
                TextButton(
                  onPressed: () => context.read<AstroSessionCubit>().logout(),
                  child: Text('Sign out', style: AppTextStyles.label(color: AppColors.ivoryDim)),
                ),
              ],
            ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
