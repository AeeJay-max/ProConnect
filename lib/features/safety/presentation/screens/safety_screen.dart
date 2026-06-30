import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants.dart';

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Safety'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Support'),
              Tab(text: 'Emergency Contacts'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              children: [
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.danger,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () => launchUrl(Uri.parse('tel:112')),
                  child: const Text('Call 112'),
                ),
                const SizedBox(height: 22),
                Text(
                  'How we protect you',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 14),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.05,
                  children: const [
                    _SafetyFeatureCard(
                      icon: Icons.shield_outlined,
                      title: 'Proactive Safety',
                    ),
                    _SafetyFeatureCard(
                      icon: Icons.verified_user_outlined,
                      title: 'Driver Verification',
                    ),
                    _SafetyFeatureCard(
                      icon: Icons.lock_outline,
                      title: 'Your Privacy Protected',
                    ),
                    _SafetyFeatureCard(
                      icon: Icons.directions_car_outlined,
                      title: 'Safety in Every Ride',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'What to do in case of an accident',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ],
            ),
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emergency Contacts',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 16,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'If needed, immediately call 112 or contact in-app support.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.local_police_outlined),
                  title: const Text('112'),
                  subtitle: const Text('Emergency assistance number'),
                  onTap: () => launchUrl(Uri.parse('tel:112')),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.support_agent_outlined),
                  title: Text('ProConnect Support'),
                  subtitle: Text('24/7 in-app assistance'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SafetyFeatureCard extends StatelessWidget {
  const _SafetyFeatureCard({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32),
          const Spacer(),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}