import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin dashboard')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        child: ListView(
          children: [
            Text('Provider verification', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: const Text('Pending provider approvals'),
                subtitle: const Text('Review new applications and verify providers.'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 16),
            Text('Transactions', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: const Text('Payments & dispute reports'),
                subtitle: const Text('View recent escrow settlements and disputes.'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 16),
            Text('Analytics', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: const Text('Platform metrics'),
                subtitle: const Text('See active users, bookings, and ratings.'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
