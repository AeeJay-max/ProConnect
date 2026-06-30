import 'package:flutter/material.dart';

import '../colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.dark = false,
    this.showTagline = false,
    this.size = 54,
  });

  final bool dark;
  final bool showTagline;
  final double size;

  @override
  Widget build(BuildContext context) {
    final textColor = dark ? AppColors.textPrimary : AppColors.textPrimary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: size,
              height: size,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.navigation_rounded,
                color: AppColors.textPrimary,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'ProConnect',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ],
        ),
        if (showTagline) ...[
          const SizedBox(height: 12),
          Text(
            'Your super app for rides and services',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ],
    );
  }
}
