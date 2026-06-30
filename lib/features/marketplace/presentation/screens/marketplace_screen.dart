import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/marketplace_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/service_provider_model.dart';

class MarketplaceScreen extends ConsumerStatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providersAsync = ref.watch(serviceProvidersStreamProvider);
    final authUser = ref.watch(authStateProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Professional'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard_customize_outlined),
            onPressed: () => context.push('/provider/dashboard'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search service providers by category, rating, and price.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _searchController,
              hintText: 'Search providers or categories',
              prefixIcon: Icons.search,
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                _MarketCategoryChip(label: 'Plumber'),
                _MarketCategoryChip(label: 'Electrician'),
                _MarketCategoryChip(label: 'Cleaner'),
                _MarketCategoryChip(label: 'Mechanic'),
              ],
            ),
            const SizedBox(height: 20),
            if (authUser != null)
              ElevatedButton(
                onPressed: () => context.push('/marketplace/requests'),
                child: const Text('View my requests'),
              ),
            const SizedBox(height: 12),
            Expanded(
              child: providersAsync.when(
                data: (providers) {
                  final filtered = providers.where((provider) {
                    final text = _searchQuery.toLowerCase();
                    return provider.name.toLowerCase().contains(text) ||
                        provider.category.toLowerCase().contains(text);
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text('No providers match your search.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final serviceProvider = filtered[index];
                      return _ProviderCard(
                        provider: serviceProvider,
                        onTap: () => context.push(
                          '/marketplace/provider/${serviceProvider.id}',
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('Unable to load providers.'),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: authUser != null
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.add_business_outlined),
              label: const Text('Become provider'),
              onPressed: () => context.push('/provider/onboarding/basic'),
            )
          : null,
    );
  }
}

class _MarketCategoryChip extends StatelessWidget {
  const _MarketCategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: () {},
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({required this.provider, required this.onTap});

  final ServiceProviderModel provider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundImage: provider.photoUrl.isNotEmpty
              ? NetworkImage(provider.photoUrl)
              : null,
          child: provider.photoUrl.isEmpty ? const Icon(Icons.person) : null,
        ),
        title: Text(provider.name),
        subtitle: Text('${provider.category} • ${provider.rating.toStringAsFixed(1)} ⭐'),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
