import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/marketplace_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class ServiceRequestScreen extends ConsumerStatefulWidget {
  const ServiceRequestScreen({super.key});

  @override
  ConsumerState<ServiceRequestScreen> createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends ConsumerState<ServiceRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();
  late String _selectedCity;

  @override
  void initState() {
    super.initState();
    _selectedCity = AppConstants.defaultCity;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = ref.watch(authStateProvider).valueOrNull;
    if (user == null) {
      return;
    }

    final success = await ref
        .read(marketplaceControllerProvider.notifier)
        .createServiceRequest(
          customerId: user.uid,
          customerCity: _selectedCity,
          category: 'Service',
          description: _descriptionController.text.trim(),
          address: _addressController.text.trim(),
          priceEstimate: double.tryParse(_priceController.text.trim()) ?? 0,
        );

    if (!mounted) {
      return;
    }

    if (success) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request submitted successfully.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit request.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request service')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _descriptionController,
                hintText: 'Describe the job in detail',
                prefixIcon: Icons.description_outlined,
                maxLines: 5,
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Please describe the work';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _addressController,
                hintText: 'Service address',
                prefixIcon: Icons.location_on_outlined,
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _selectedCity,
                items: AppConstants.kazakhstanCities
                    .map(
                      (city) => DropdownMenuItem(
                        value: city['name'],
                        child: Text(city['name'] ?? ''),
                      ),
                    )
                    .toList(),
                decoration: const InputDecoration(hintText: 'City'),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCity = value);
                  }
                },
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _priceController,
                hintText: 'Estimated budget',
                prefixIcon: Icons.attach_money_outlined,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Please enter an estimated budget';
                  }
                  if (double.tryParse(value!.trim()) == null) {
                    return 'Enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 22),
              AppButton(
                text: 'Submit request',
                onPressed: _submitRequest,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
