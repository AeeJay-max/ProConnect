import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/marketplace_providers.dart';

class ServiceQuoteScreen extends ConsumerStatefulWidget {
  const ServiceQuoteScreen({super.key, required this.requestId});

  final String requestId;

  @override
  ConsumerState<ServiceQuoteScreen> createState() => _ServiceQuoteScreenState();
}

class _ServiceQuoteScreenState extends ConsumerState<ServiceQuoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitQuote(String customerId, String providerId) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await ref.read(marketplaceControllerProvider.notifier).submitServiceQuote(
          requestId: widget.requestId,
          providerId: providerId,
          customerId: customerId,
          amount: double.tryParse(_amountController.text.trim()) ?? 0.0,
          message: _messageController.text.trim(),
        );

    if (!mounted) {
      return;
    }

    if (success) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quote submitted successfully.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit quote.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestAsync = ref.watch(serviceRequestProvider(widget.requestId));

    return Scaffold(
      appBar: AppBar(title: const Text('Submit service quote')),
      body: requestAsync.when(
        data: (request) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Request details',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(request.description),
                  const SizedBox(height: 12),
                  Text('Location: ${request.address}'),
                  const SizedBox(height: 12),
                  Text('Estimated budget: \$${request.priceEstimate.toStringAsFixed(2)}'),
                  const SizedBox(height: 24),
                  AppTextField(
                    controller: _amountController,
                    hintText: 'Offer amount',
                    prefixIcon: Icons.attach_money_outlined,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Enter your quote amount';
                      }
                      if (double.tryParse(value!.trim()) == null) {
                        return 'Enter a valid amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _messageController,
                    hintText: 'Message to customer',
                    prefixIcon: Icons.message_outlined,
                    maxLines: 4,
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Write a short message for the customer';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'Send quote',
                    onPressed: () => _submitQuote(request.customerId, request.providerId),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const Center(child: Text('Unable to load request details.')),
      ),
    );
  }
}
