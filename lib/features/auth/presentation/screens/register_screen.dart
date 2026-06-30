import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/auth_providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedRole = 'customer';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final success =
        await ref.read(authControllerProvider.notifier).registerWithEmail(
              _emailController.text.trim(),
              _passwordController.text.trim(),
              _nameController.text.trim(),
              _phoneController.text.trim(),
              _selectedRole,
            );

    if (!mounted) return;

    if (success) {
      if (_selectedRole == 'serviceProvider') {
        context.go('/provider/onboarding/basic');
      } else {
        context.go('/home');
      }
    } else {
      _showError(
        ref.read(authControllerProvider).error ??
            'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final success =
        await ref.read(authControllerProvider.notifier).signInWithGoogle();

    if (!mounted) return;

    if (success) {
      context.go('/home');
    } else {
      _showError(
        ref.read(authControllerProvider).error ??
            'Google sign-in failed. Please try again.',
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.danger,
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create your account',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 24),

                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    hintText: 'Account type',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'customer',
                      child: Text('Customer'),
                    ),
                    DropdownMenuItem(
                      value: 'driver',
                      child: Text('Driver'),
                    ),
                    DropdownMenuItem(
                      value: 'serviceProvider',
                      child: Text('Service Provider'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedRole = value);
                    }
                  },
                ),

                const SizedBox(height: 16),

                AppTextField(
                  controller: _nameController,
                  hintText: 'Full name',
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                AppTextField(
                  controller: _phoneController,
                  hintText: 'Phone number',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                AppTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(text)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                AppTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                AppTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                AppButton(
                  text: 'Create account',
                  isLoading: authState.isLoading,
                  onPressed: _handleRegister,
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 20),

                OutlinedButton(
                  onPressed:
                      authState.isLoading ? null : _handleGoogleSignIn,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: const Text(
                          'G',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('Sign in with Google'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('Sign in'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}