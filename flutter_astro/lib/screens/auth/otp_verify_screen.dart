import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../services/api_service.dart';
import '../home/home_screen.dart';

/// Email-OTP verification for the short signup flow. On success the backend
/// returns tokens (stored by ApiService) and we route straight into the app;
/// the HomeScreen onboarding gate then collects personal / professional / KYC.
class OtpVerifyScreen extends StatefulWidget {
  final String email;
  final String name;
  const OtpVerifyScreen({super.key, required this.email, required this.name});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final _otpCtrl = TextEditingController();
  final _api = ApiService();
  bool _verifying = false;
  int _resendIn = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _resendIn = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _resendIn = _resendIn > 0 ? _resendIn - 1 : 0);
      if (_resendIn == 0) t.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpCtrl.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final otp = _otpCtrl.text.trim();
    if (otp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter the 6-digit code')));
      return;
    }
    setState(() => _verifying = true);
    try {
      final resp = await _api.signupVerifyOtp(email: widget.email, otp: otp);
      if (!mounted) return;
      if (resp['statusCode'] == 200) {
        // Tokens are stored; refresh auth state and enter the app.
        context.read<AuthBloc>().add(AuthCheckRequested());
        Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(resp['detail']?.toString() ?? 'Invalid or expired code'),
          backgroundColor: AppColors.error));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'), backgroundColor: AppColors.error));
    }
    if (mounted) setState(() => _verifying = false);
  }

  Future<void> _resend() async {
    if (_resendIn > 0) return;
    try {
      await _api.signupResendOtp(widget.email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('A new code has been sent')));
        _startCountdown();
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(height: 24),
            const Icon(Icons.mark_email_read_outlined, size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            const Text('Verify your email', style: TextStyle(color: AppColors.primary, fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('We sent a 6-digit code to\n${widget.email}',
                textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
              child: Column(children: [
                TextField(
                  controller: _otpCtrl,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 26, letterSpacing: 12, fontWeight: FontWeight.w700),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(counterText: '', hintText: '••••••', hintStyle: TextStyle(color: AppColors.textSecondary, letterSpacing: 12)),
                  onSubmitted: (_) => _verify(),
                ),
                const SizedBox(height: 16),
                SizedBox(width: double.infinity, child: ElevatedButton(
                  onPressed: _verifying ? null : _verify,
                  child: _verifying
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                      : const Text('Verify & Continue'),
                )),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _resendIn > 0 ? null : _resend,
                  child: Text(
                    _resendIn > 0 ? 'Resend code in ${_resendIn}s' : 'Resend code',
                    style: TextStyle(color: _resendIn > 0 ? AppColors.textSecondary : AppColors.primary),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }
}
