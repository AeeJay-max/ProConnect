import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/location_provider.dart';
import '../widgets/city_row.dart';
import '../widgets/service_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final userModel = ref.watch(userModelProvider).valueOrNull;
    final firebaseUser = ref.watch(authStateProvider).valueOrNull;
    final city = ref.watch(selectedCityProvider);
    final displayName = userModel?.name.isNotEmpty == true
        ? userModel!.name
        : firebaseUser?.displayName ?? 'Guest';

    return Scaffold(
      appBar: AppBar(
        title: const Text('What do you need today?'),
        actions: [
          IconButton(
            onPressed: () => context.push('/notifications'),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          IconButton(
            onPressed: () => context.push('/emergency/sos'),
            icon: const Icon(Icons.report_problem_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        children: [
          Row(
            children: [
              _HomeAvatar(
                name: displayName,
                photoUrl: userModel?.photoUrl ?? firebaseUser?.photoURL,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, $displayName',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Choose a path to get moving or get help today',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ServiceCard(
            icon: Icons.directions_car_outlined,
            title: 'Book a Ride',
            subtitle: 'Continue with the existing city and intercity ride flow',
            onTap: () => context.push('/ride'),
          ),
          ServiceCard(
            icon: Icons.handyman_outlined,
            title: 'Find a Professional',
            subtitle: 'Search trusted service providers and request a quote',
            onTap: () => context.push('/marketplace'),
          ),
          const SizedBox(height: 16),
          Text(
            'Popular services',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _CategoryChip(label: 'Plumber', icon: Icons.plumbing),
              _CategoryChip(label: 'Electrician', icon: Icons.electrical_services),
              _CategoryChip(label: 'Cleaner', icon: Icons.cleaning_services),
              _CategoryChip(label: 'Mechanic', icon: Icons.build),
            ],
          ),
          const SizedBox(height: 24),
          CityRow(
            cityName: city,
            onChangeCity: () => context.push('/select-city'),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      avatar: Icon(icon, size: 18),
      onPressed: () {},
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}

class _HomeAvatar extends StatelessWidget {
  const _HomeAvatar({required this.name, this.photoUrl});

  final String name;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return CircleAvatar(radius: 22, backgroundImage: NetworkImage(photoUrl!));
    }

    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part.substring(0, 1).toUpperCase())
        .join();

    return CircleAvatar(
      radius: 22,
      child: Text(initials.isEmpty ? 'ID' : initials),
    );
  }
}
