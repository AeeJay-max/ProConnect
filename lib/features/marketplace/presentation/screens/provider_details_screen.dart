import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/marketplace_providers.dart';
import '../../../../core/widgets/app_button.dart';

class ProviderDetailsScreen extends ConsumerWidget {
  const ProviderDetailsScreen({super.key, required this.providerId});

  final String providerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerAsync = ref.watch(providerDetailsProvider(providerId));

    return Scaffold(
      appBar: AppBar(title: const Text('Provider details')),
      body: providerAsync.when(
        data: (provider) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: provider.photoUrl.isNotEmpty
                      ? NetworkImage(provider.photoUrl)
                      : null,
                  child: provider.photoUrl.isEmpty ? const Icon(Icons.person, size: 42) : null,
                ),
                const SizedBox(height: 16),
                Text(provider.name, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(provider.category, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Text('${provider.rating.toStringAsFixed(1)} ⭐ • ${provider.reviewCount} reviews'),
                const SizedBox(height: 16),
                Text(provider.bio),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: provider.skills
                      .map((skill) => Chip(label: Text(skill)))
                      .toList(),
                ),
                const Spacer(),
                AppButton(
                  text: 'Request service',
                  onPressed: () => context.push('/service/request/create'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const Center(child: Text('Provider details could not be loaded.')),
      ),
    );
  }
}
