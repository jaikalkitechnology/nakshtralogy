import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../widgets/desktop_center.dart';

enum PasswordOtpMode { forgot, change }

/// Unified OTP-based password screen used for BOTH:
///  • Forgot password (login screen) — enter email → OTP → new password
///  • Change password (profile)      — logged-in email → OTP → new password
/// Step 1 sends the OTP; step 2 verifies it and sets the new password.
class PasswordOtpScreen extends StatefulWidget {
  final PasswordOtpMode mode;
  /// For `change` mode: the logged-in user's email (display only).
  final String? email;
  const PasswordOtpScreen({super.key, required this.mode, this.email});

  @override
  State<PasswordOtpScreen> createState() => _PasswordOtpScreenState();
}

class _PasswordOtpScreenState extends State<PasswordOtpScreen> {
  final _api = ApiService();
  final _emailCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _sent = false;
  bool _busy = false;
  bool _obscure = true;
  int _resendIn = 0;
  Timer? _timer;

  bool get _isChange => widget.mode == PasswordOtpMode.change;

  @override
  void initState() {
    super.initState();
    if (widget.email != null) _emailCtrl.text = widget.email!;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailCtrl.dispose(); _otpCtrl.dispose();
    _passCtrl.dispose(); _confirmCtrl.dispose();
    super.dispose();
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

  void _toast(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg), backgroundColor: error ? AppColors.error : AppColors.success));
  }

  Future<void> _sendOtp() async {
    if (!_isChange) {
      final email = _emailCtrl.text.trim();
      if (!email.contains('@')) { _toast('Enter a valid email', error: true); return; }
    }
    setState(() => _busy = true);
    try {
      final resp = _isChange
          ? await _api.changePasswordSendOtp()
          : await _api.forgotPasswordSendOtp(_emailCtrl.text.trim());
      if (!mounted) return;
      final ok = resp['statusCode'] == 200;
      if (ok) {
        setState(() => _sent = true);
        _startCountdown();
        _toast(resp['message']?.toString() ?? 'Code sent to your email');
      } else {
        _toast(resp['detail']?.toString() ?? 'Could not send code', error: true);
      }
    } catch (e) {
      _toast('$e', error: true);
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _submit() async {
    final otp = _otpCtrl.text.trim();
    final pass = _passCtrl.text;
    if (otp.length < 4) { _toast('Enter the 6-digit code', error: true); return; }
    if (pass.length < 6) { _toast('Password must be at least 6 characters', error: true); return; }
    if (pass != _confirmCtrl.text) { _toast('Passwords do not match', error: true); return; }
    setState(() => _busy = true);
    try {
      final resp = _isChange
          ? await _api.changePasswordWithOtp(otp: otp, newPassword: pass)
          : await _api.forgotPasswordReset(email: _emailCtrl.text.trim(), otp: otp, newPassword: pass);
      if (!mounted) return;
      if (resp['statusCode'] == 200) {
        _toast(resp['message']?.toString() ?? 'Password updated');
        await Future.delayed(const Duration(milliseconds: 600));
        if (mounted) Navigator.pop(context, true);
      } else {
        _toast(resp['detail']?.toString() ?? 'Could not update password', error: true);
      }
    } catch (e) {
      _toast('$e', error: true);
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final title = _isChange ? 'Change Password' : l.forgotPassword;
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: DesktopCenter(
          maxWidth: 520,
          child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            const SizedBox(height: 28),
            Icon(_isChange ? Icons.lock_outline : Icons.lock_reset, size: 60, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(
              _sent
                  ? 'Enter the code we emailed you and set a new password'
                  : (_isChange
                      ? 'We\'ll email a verification code to\n${_emailCtrl.text}'
                      : l.forgotPasswordInstructions),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border)),
              child: Column(children: [
                if (!_isChange)
                  TextField(
                    controller: _emailCtrl,
                    enabled: !_sent,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(labelText: l.email, prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary)),
                  ),
                if (!_sent) ...[
                  if (!_isChange) const SizedBox(height: 16),
                  SizedBox(width: double.infinity, child: ElevatedButton(
                    onPressed: _busy ? null : _sendOtp,
                    child: _busy
                        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                        : const Text('Send Code'),
                  )),
                ],
                if (_sent) ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: _otpCtrl,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 6,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, letterSpacing: 10, fontWeight: FontWeight.w700),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(counterText: '', hintText: '••••••', hintStyle: TextStyle(color: AppColors.textSecondary, letterSpacing: 10)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passCtrl,
                    obscureText: _obscure,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'New password',
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.textSecondary),
                        onPressed: () => setState(() => _obscure = !_obscure)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _confirmCtrl,
                    obscureText: true,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(labelText: 'Confirm new password', prefixIcon: Icon(Icons.lock_outline, color: AppColors.textSecondary)),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(width: double.infinity, child: ElevatedButton(
                    onPressed: _busy ? null : _submit,
                    child: _busy
                        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                        : const Text('Update Password'),
                  )),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _resendIn > 0 || _busy ? null : _sendOtp,
                    child: Text(
                      _resendIn > 0 ? 'Resend code in ${_resendIn}s' : 'Resend code',
                      style: TextStyle(color: _resendIn > 0 ? AppColors.textSecondary : AppColors.primary),
                    ),
                  ),
                ],
              ]),
            ),
            const SizedBox(height: 24),
          ]),
        )),
      ),
    );
  }
}
