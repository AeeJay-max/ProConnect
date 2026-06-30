import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/service_provider_model.dart';
import '../providers/marketplace_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class ProviderOnboardingScreen extends ConsumerStatefulWidget {
  const ProviderOnboardingScreen({super.key});

  @override
  ConsumerState<ProviderOnboardingScreen> createState() => _ProviderOnboardingScreenState();
}

class _ProviderOnboardingScreenState extends ConsumerState<ProviderOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _bioController = TextEditingController();
  final _skillsController = TextEditingController();
  final _addressController = TextEditingController();
  final _hourlyRateController = TextEditingController();

  @override
  void dispose() {
    _businessNameController.dispose();
    _categoryController.dispose();
    _bioController.dispose();
    _skillsController.dispose();
    _addressController.dispose();
    _hourlyRateController.dispose();
    super.dispose();
  }

  Future<void> _submitProviderProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = ref.watch(authStateProvider).valueOrNull;
    if (user == null) {
      return;
    }

    final profile = ServiceProviderModel(
      id: user.uid,
      userId: user.uid,
      name: _businessNameController.text.trim(),
      photoUrl: '',
      category: _categoryController.text.trim(),
      bio: _bioController.text.trim(),
      skills: _skillsController.text.trim().split(',').map((e) => e.trim()).toList(),
      certifications: ['National ID', 'Certification'],
      experienceYears: 2,
      hourlyRate: double.tryParse(_hourlyRateController.text.trim()) ?? 0,
      rating: 0,
      reviewCount: 0,
      available: true,
      city: AppConstants.defaultCity,
      address: _addressController.text.trim(),
      serviceRadiusKm: 15,
      createdAt: null,
      updatedAt: null,
    );

    final success = await ref
        .read(marketplaceControllerProvider.notifier)
        .publishProviderProfile(profile: profile);

    if (!mounted) {
      return;
    }

    if (success) {
      context.go('/provider/dashboard');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Provider onboarding submitted.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit provider profile.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Service provider onboarding')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _businessNameController,
                hintText: 'Business or full name',
                prefixIcon: Icons.business_center_outlined,
                validator: (value) => (value ?? '').trim().isEmpty ? 'Enter your business name' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _categoryController,
                hintText: 'Service category',
                prefixIcon: Icons.category_outlined,
                validator: (value) => (value ?? '').trim().isEmpty ? 'Enter service category' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _bioController,
                hintText: 'Short bio',
                prefixIcon: Icons.info_outline,
                maxLines: 3,
                validator: (value) => (value ?? '').trim().isEmpty ? 'Enter a short bio' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _skillsController,
                hintText: 'Skills (comma separated)',
                prefixIcon: Icons.list_alt_outlined,
                validator: (value) => (value ?? '').trim().isEmpty ? 'List your core skills' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _addressController,
                hintText: 'Service address or coverage area',
                prefixIcon: Icons.location_on_outlined,
                validator: (value) => (value ?? '').trim().isEmpty ? 'Enter your address or service area' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _hourlyRateController,
                hintText: 'Hourly rate',
                prefixIcon: Icons.attach_money_outlined,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Enter your hourly rate';
                  }
                  if (double.tryParse(value!.trim()) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              AppButton(
                text: 'Submit provider profile',
                onPressed: _submitProviderProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
