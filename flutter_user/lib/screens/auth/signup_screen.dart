import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../home/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose();
    _passCtrl.dispose(); _confirmCtrl.dispose();
    super.dispose();
  }

  void _signup() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(AuthSignupRequested(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      phone: _phoneCtrl.text.trim().isNotEmpty ? _phoneCtrl.text.trim() : null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
        }
      },
      child: Scaffold(
        appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context))),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: [
              const SizedBox(height: 20),
              const Text('\u2728', style: TextStyle(fontSize: 44)),
              const SizedBox(height: 8),
              Text('Create Account', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 24)),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline, color: AppColors.textSecondary)), validator: (v) => (v == null || v.length < 2) ? 'Enter your name' : null),
                    const SizedBox(height: 16),
                    TextFormField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined, color: AppColors.textSecondary)), validator: (v) => (v == null || !v.contains('@')) ? 'Valid email required' : null),
                    const SizedBox(height: 16),
                    TextFormField(controller: _phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone (optional)', prefixIcon: Icon(Icons.phone_outlined, color: AppColors.textSecondary))),
                    const SizedBox(height: 16),
                    TextFormField(controller: _passCtrl, obscureText: _obscure, decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary), suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.textSecondary), onPressed: () => setState(() => _obscure = !_obscure))), validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null),
                    const SizedBox(height: 16),
                    TextFormField(controller: _confirmCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm Password', prefixIcon: Icon(Icons.lock_outline, color: AppColors.textSecondary)), validator: (v) => v != _passCtrl.text ? 'Passwords do not match' : null),
                    const SizedBox(height: 24),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final loading = state is AuthLoading;
                        return ElevatedButton(
                          onPressed: loading ? null : _signup,
                          child: loading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)) : const Text('Create Account'),
                        );
                      },
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Already have an account? ', style: TextStyle(color: AppColors.textSecondary)),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Sign In', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600))),
              ]),
              const SizedBox(height: 20),
            ]),
          ),
        ),
      ),
    );
  }
}
