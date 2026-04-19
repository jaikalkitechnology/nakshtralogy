import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/kyc/kyc_bloc.dart';
import '../../bloc/kyc/kyc_event.dart';
import '../../bloc/kyc/kyc_state.dart';
import '../../services/api_service.dart';

class KycSubmitScreen extends StatefulWidget {
  const KycSubmitScreen({super.key});

  @override
  State<KycSubmitScreen> createState() => _KycSubmitScreenState();
}

class _KycSubmitScreenState extends State<KycSubmitScreen> {
  final _docNumberCtrl = TextEditingController();
  final _api = ApiService();
  String _docType = 'aadhaar';
  String? _frontUrl;
  String? _backUrl;
  String? _selfieUrl;
  String? _frontFileName;
  String? _backFileName;
  String? _selfieFileName;
  bool _uploading = false;

  @override
  void dispose() {
    _docNumberCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAndUpload(String field) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Select ${field == 'selfie' ? 'Selfie' : 'Document'}',
              style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.camera_alt, color: AppColors.gold),
            title: const Text('Camera', style: TextStyle(color: AppColors.ivory)),
            onTap: () => Navigator.pop(ctx, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: AppColors.gold),
            title: const Text('Gallery', style: TextStyle(color: AppColors.ivory)),
            onTap: () => Navigator.pop(ctx, ImageSource.gallery),
          ),
        ]),
      ),
    );
    if (source == null) return;

    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: source, imageQuality: 80, maxWidth: 1200);
    if (picked == null) return;

    final file = File(picked.path);

    setState(() => _uploading = true);
    try {
      final resp = await _api.uploadKycFile(picked.path, picked.name);
      if (resp['statusCode'] == 200) {
        setState(() {
          switch (field) {
            case 'front':
              _frontUrl = resp['media_url'];
              _frontFileName = resp['file_name'];
              break;
            case 'back':
              _backUrl = resp['media_url'];
              _backFileName = resp['file_name'];
              break;
            case 'selfie':
              _selfieUrl = resp['media_url'];
              _selfieFileName = resp['file_name'];
              break;
          }
        });
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${resp['file_name']} uploaded'), backgroundColor: AppColors.success));
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resp['detail'] ?? 'Upload failed'), backgroundColor: AppColors.error));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error));
    }
    setState(() => _uploading = false);
  }

  void _submit() {
    if (_docNumberCtrl.text.trim().isEmpty || _frontUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document number and front image are required')),
      );
      return;
    }
    context.read<KycBloc>().add(KycSubmitRequested(
      docType: _docType,
      docNumber: _docNumberCtrl.text.trim(),
      frontUrl: _frontUrl,
      backUrl: _backUrl,
      selfieUrl: _selfieUrl,
    ));
  }

  Widget _uploadButton(String label, String field, String? fileName) {
    return GestureDetector(
      onTap: _uploading ? null : () => _pickAndUpload(field),
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: fileName != null ? AppColors.success.withOpacity(0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: fileName != null ? AppColors.success.withOpacity(0.4) : AppColors.border),
        ),
        child: Row(children: [
          Icon(
            fileName != null ? Icons.check_circle : Icons.upload_file,
            color: fileName != null ? AppColors.success : AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
            if (fileName != null)
              Text(fileName, style: const TextStyle(color: AppColors.success, fontSize: 11))
            else
              const Text('Tap to upload image or PDF', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          ])),
          Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<KycBloc, KycState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error!), backgroundColor: AppColors.error));
        }
      },
      builder: (context, state) {
        final isRejected = state.status == 'rejected';
        return Scaffold(
          appBar: AppBar(
            title: const Text('KYC Verification'),
            actions: [
              IconButton(icon: const Icon(Icons.logout), onPressed: () => context.read<AuthBloc>().add(AuthLogoutRequested())),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              // Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (isRejected ? AppColors.error : AppColors.primary).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: (isRejected ? AppColors.error : AppColors.primary).withOpacity(0.4)),
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(isRejected ? Icons.error_outline : Icons.shield_outlined, color: isRejected ? AppColors.error : AppColors.primary, size: 24),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(isRejected ? 'KYC Rejected — Please Re-submit' : 'KYC Verification Required',
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      isRejected ? 'Your previous submission was not accepted. Please fix the issues and re-submit.'
                          : 'Complete your KYC to unlock all features and start accepting consultations.',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                    ),
                    if (isRejected && state.rejectionReason != null) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.error.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
                        child: Text('Reason: ${state.rejectionReason!}', style: const TextStyle(color: AppColors.error, fontSize: 10)),
                      ),
                    ],
                  ])),
                ]),
              ),
              const SizedBox(height: 20),

              // Form
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Submit KYC Documents', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _docType,
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
                    decoration: const InputDecoration(labelText: 'Document Number *', prefixIcon: Icon(Icons.numbers)),
                  ),
                  const SizedBox(height: 16),
                  const Text('Upload Documents', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 8),
                  _uploadButton('Front Image *', 'front', _frontFileName),
                  _uploadButton('Back Image (optional)', 'back', _backFileName),
                  _uploadButton('Selfie with Document (optional)', 'selfie', _selfieFileName),
                  if (_uploading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
                        SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
                        SizedBox(width: 8),
                        Text('Uploading...', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ])),
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.submitting || _uploading ? null : _submit,
                      child: state.submitting
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Submit for Review'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Documents are reviewed manually (24–48 hours).', textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                ]),
              ),
            ]),
          ),
        );
      },
    );
  }
}
