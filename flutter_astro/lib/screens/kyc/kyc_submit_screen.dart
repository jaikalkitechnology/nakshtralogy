import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/kyc/kyc_bloc.dart';
import '../../bloc/kyc/kyc_event.dart';
import '../../bloc/kyc/kyc_state.dart';

/// Shown when KYC status is 'none' or 'rejected'. Lets the astrologer
/// submit (or resubmit) KYC documents.
class KycSubmitScreen extends StatefulWidget {
  const KycSubmitScreen({super.key});

  @override
  State<KycSubmitScreen> createState() => _KycSubmitScreenState();
}

class _KycSubmitScreenState extends State<KycSubmitScreen> {
  final _docNumberCtrl = TextEditingController();
  final _frontCtrl = TextEditingController();
  final _backCtrl = TextEditingController();
  final _selfieCtrl = TextEditingController();
  String _docType = 'aadhaar';

  @override
  void dispose() {
    _docNumberCtrl.dispose();
    _frontCtrl.dispose();
    _backCtrl.dispose();
    _selfieCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_docNumberCtrl.text.trim().isEmpty || _frontCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document number and front image URL are required')),
      );
      return;
    }
    context.read<KycBloc>().add(KycSubmitRequested(
          docType: _docType,
          docNumber: _docNumberCtrl.text.trim(),
          frontUrl: _frontCtrl.text.trim(),
          backUrl: _backCtrl.text.trim().isEmpty ? null : _backCtrl.text.trim(),
          selfieUrl: _selfieCtrl.text.trim().isEmpty ? null : _selfieCtrl.text.trim(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<KycBloc, KycState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: AppColors.error),
          );
        }
      },
      builder: (context, state) {
        final isRejected = state.status == 'rejected';
        return Scaffold(
          appBar: AppBar(
            title: const Text('KYC Verification'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isRejected
                        ? AppColors.error.withValues(alpha: 0.1)
                        : AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isRejected
                          ? AppColors.error.withValues(alpha: 0.4)
                          : AppColors.primary.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isRejected ? Icons.error_outline : Icons.shield_outlined,
                        color: isRejected ? AppColors.error : AppColors.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isRejected ? 'KYC Rejected — Please Re-submit' : 'KYC Verification Required',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isRejected
                                  ? 'Your previous submission was not accepted. Please fix the issues and re-submit.'
                                  : 'Complete your KYC to unlock all features and start accepting consultations.',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                            if (isRejected && state.rejectionReason != null) ...[
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.error.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Reason:',
                                        style: TextStyle(
                                            color: AppColors.error, fontSize: 10, fontWeight: FontWeight.bold)),
                                    Text(
                                      state.rejectionReason!,
                                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Form card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Submit KYC Documents',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _docType,
                        decoration: const InputDecoration(labelText: 'Document Type *'),
                        dropdownColor: AppColors.card,
                        style: const TextStyle(color: AppColors.textPrimary),
                        items: const [
                          DropdownMenuItem(value: 'aadhaar', child: Text('Aadhaar Card')),
                          DropdownMenuItem(value: 'pan', child: Text('PAN Card')),
                          DropdownMenuItem(value: 'passport', child: Text('Passport')),
                          DropdownMenuItem(value: 'license', child: Text('Driving License')),
                          DropdownMenuItem(value: 'certificate', child: Text('Astrology Certificate')),
                        ],
                        onChanged: (v) => setState(() => _docType = v ?? 'aadhaar'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _docNumberCtrl,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(labelText: 'Document Number *'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _frontCtrl,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          labelText: 'Front Image URL *',
                          hintText: 'https://… upload via your asset host',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _backCtrl,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(labelText: 'Back Image URL (optional)'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _selfieCtrl,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          labelText: 'Selfie with Document (optional)',
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state.submitting ? null : _submit,
                          child: state.submitting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Submit for Review'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Documents are reviewed manually (24–48 hours). You will be notified when approved.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
