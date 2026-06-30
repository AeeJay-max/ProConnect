import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../settings/presentation/providers/settings_provider.dart';

class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '24/7',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceTint,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.support_agent_rounded,
                    size: 70,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Support is always near',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'If you are unsure — contact us 24/7 through in-app support',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 28),
              AppButton(
                text: 'Contact us',
                onPressed: () async {
                  await ref.read(settingsProvider.notifier).markWarningsSeen();
                  if (context.mounted) {
                    context.go('/safety');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}