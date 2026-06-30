import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/widgets/app_button.dart';

class WarningLinksScreen extends StatelessWidget {
  const WarningLinksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Center(
                child: CircleAvatar(
                  radius: 54,
                  backgroundColor: AppColors.surface,
                  child: Icon(
                    Icons.close_rounded,
                    size: 62,
                    color: AppColors.danger,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Be careful with links',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Do not open links from strangers. This may be a scam. Use only verified links from the official app.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 28),
              AppButton(
                text: 'Got it',
                onPressed: () => context.go('/onboarding/support'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}